extends KinematicBody2D
class_name Player

var move_accel := 800
var max_speed := 300
var velocity := Vector2.ZERO

#######################################################################33
# ready

var initial_pos


func _ready():
	initial_pos = get_global_position()
	anim.flip_h = facing == facing_dir.RIGHT

	call_deferred("setup")


func setup():
	add_info_message(health_info_dict(health))


#######################################################################33
# facing

onready var anim = $AnimatedSprite
enum facing_dir { RIGHT, DOWN, LEFT, UP }
var facing = facing_dir.RIGHT


func update_facing(move_dir):
	var new_facing
	if abs(move_dir.x) > 0:
		new_facing = facing_dir.RIGHT if move_dir.x > 0 else facing_dir.LEFT
	elif abs(move_dir.y) > 0:
		new_facing = facing_dir.DOWN if move_dir.y > 0 else facing_dir.UP

	if new_facing != null and new_facing != facing:
		facing = new_facing
		anim.flip_h = facing == facing_dir.RIGHT
		point_weapon(facing)


#######################################################################33
# process


func _process(delta):
	var move_dir = Trolley.move_dir()
	update_facing(move_dir)
	if move_dir.length() == 0:
		velocity = lerp(velocity, Vector2.ZERO, 0.5)
	else:
		velocity += move_accel * move_dir * delta
		velocity = velocity.limit_length(max_speed)
	if velocity.x > 0.1 or velocity.y > 0.1:
		anim.animation = "run"
	else:
		anim.animation = "idle"
	velocity = move_and_slide(velocity)

	# TODO cache or otherwise store current_target
	# TODO animate rotation, pass delta in
	point_at_target()

	pull_items(delta)


#######################################################################33
# _input


func _unhandled_input(event):
	if Trolley.is_action(event):
		if actions:
			# TODO selecting when there are multiple actions
			var ax = actions[0]
			execute_action(ax)
		elif weapon:
			# one button for everything?
			use_weapon(weapon)

	if Trolley.is_attack(event):
		if weapon:
			use_weapon(weapon)


#######################################################################33
# weapons

onready var weapon_pos = $WeaponPosition
var weapon


func update_weapon():
	if weapons.size():
		# TODO select new weapon? keep current?
		weapon = weapons[0]
	else:
		weapon = null

	if weapon:
		match weapon["type"]:
			"bow":
				attach_bow()


func use_weapon(wp = null):
	if not wp:
		wp = weapon

	match wp["type"]:
		"bow":
			fire_bow()


func point_weapon(dir):
	if weapon:
		match weapon["type"]:
			"bow":
				point_bow(dir)


const weapons = []


func add_weapon(wp):
	weapons.append(wp)
	print("[player weapons]: ", weapons)

	update_weapon()


func remove_weapon(wp):
	weapons.erase(wp)
	print("[player weapons]: ", weapons)


# bow

var player_bow_scene = preload("res://src/dungeonCrawler/weapons/BowWeapon.tscn")


func attach_bow():
	var bow = player_bow_scene.instance()
	call_deferred("add_child", bow)
	bow.transform.origin = weapon_pos.position


var arrow_scene = preload("res://src/dungeonCrawler/weapons/ArrowProjectile.tscn")
var arrow_impulse = 400


func fire_bow():
	var bow = Util.get_first_child_in_group(self, "bow")
	if not bow:
		print("[WARN]: attempted to fire bow, but no bow found (expected node group 'bow')")
		return

	var arrow = arrow_scene.instance()
	arrow.position = bow.get_global_position()  # maybe use weapon position?
	# prefer to add bullets to the current scene, so they get cleaned up
	Navi.current_scene.call_deferred("add_child", arrow)
	arrow.rotation_degrees = bow.rotation_degrees + 90
	var impulse_dir = Vector2(1, 0).rotated(deg2rad(bow.rotation_degrees))
	arrow.apply_impulse(Vector2.ZERO, impulse_dir * arrow_impulse)


func point_bow(dir):
	var bow = Util.get_first_child_in_group(self, "bow")
	if bow:
		match dir:
			facing_dir.RIGHT:
				bow.transform.origin = weapon_pos.position / 2
				bow.rotation_degrees = 0
			facing_dir.LEFT:
				bow.transform.origin = Vector2(-weapon_pos.position.x, weapon_pos.position.y) / 2
				bow.rotation_degrees = 180
			facing_dir.UP:
				bow.transform.origin = (
					Vector2(0, -weapon_pos.position.x + weapon_pos.position.y)
					/ 2
				)
				bow.rotation_degrees = -90
			facing_dir.DOWN:
				bow.transform.origin = Vector2(0, weapon_pos.position.x + weapon_pos.position.y) / 2
				bow.rotation_degrees = 90


#######################################################################33
# coins

var coins = 0


func add_coin():
	coins += 1

	remove_info_message(coin_info_dict(coins - 1))
	add_info_message(coin_info_dict(coins))


func coin_info_dict(c):
	return {"label": str("Coins: ", c)}


#######################################################################33
# items

const items = []


func add_item(it):
	items.append(it)
	print("[player items]: ", items)
	update_item_info()


func remove_item(it):
	items.erase(it)
	print("[player items]: ", items)
	update_item_info()


func update_item_info():
	var key_ct = 0
	for it in items:
		if it.get("type") == "key":
			key_ct += 1

	remove_info_message({"label": str("Keys: ", 1)})
	remove_info_message({"label": str("Keys: ", 2)})
	if key_ct > 0:
		add_info_message({"label": str("Keys: ", key_ct)})


#######################################################################33
# doors/keys


func can_lock_door():
	return false


func can_unlock_door():
	for it in items:
		if it["type"] == "key":
			return true
	return false


func use_key():
	# TODO how to determine/sort small vs boss key?
	var key_item
	for it in items:
		if it["type"] == "key":
			key_item = it

	if key_item:
		remove_item(key_item)


#######################################################################33
# actions

const actions = []

var action_label_scene = preload("res://src/dungeonCrawler/player/ActionLabel.tscn")
onready var actions_list = $ActionsList


func add_action(ax):
	var label_text = ax.get("label", "fallback label")
	var new_label = action_label_scene.instance()
	new_label.bbcode_text = "[center]" + label_text
	actions_list.add_child(new_label)
	actions.append(ax)


func remove_action(ax):
	var to_remove
	for action_label in actions_list.get_children():
		if action_label.text == ax.get("label", "fallback label"):
			to_remove = action_label
			break

	if to_remove:
		actions_list.remove_child(to_remove)

	actions.erase(ax)


func execute_action(ax):
	var fn = ax["func"]
	# TODO big assumption here, passing self as first arg
	# really not sure about this pattern vs pubsub
	fn.call_func(self)

	remove_action(ax)


#######################################################################33
# targets
# can pretty much lock-on to everything

var bodies = []


func _on_LockOnDetectArea2D_body_entered(body: Node):
	# TODO ignore tilemaps properly, maybe via collision layers
	if body != self and body.name != "DungeonWalls":
		bodies.append(body)
		# print("[player-lockon-bodies]:", bodies)


func _on_LockOnDetectArea2D_body_exited(body: Node):
	bodies.erase(body)
	# print("[player-lockon-bodies]:", bodies)


var areas = []


func _on_LockOnDetectArea2D_area_entered(area: Area2D):
	areas.append(area)
	# print("[player-lockon-areas]:", areas)


func _on_LockOnDetectArea2D_area_exited(area: Area2D):
	areas.erase(area)
	# print("[player-lockon-areas]:", areas)


onready var line_of_sight = $LineOfSightRayCast2D


func in_line_of_sight(body):
	var cast_to = to_local(body.global_position)
	line_of_sight.cast_to = cast_to
	line_of_sight.force_raycast_update()
	if line_of_sight.is_colliding():
		var collider = line_of_sight.get_collider()
		if collider == body:
			return true
	return false


var targets = []


func current_target():
	# TODO sort by 'closest'
	if bodies.size():
		for body in bodies:
			if in_line_of_sight(body) and not body.get("dead"):
				return body
	if areas.size():
		return areas[0]


func point_at_target():
	var target = current_target()
	if target:
		# TODO should probably be generic (vs bow specific)
		var bow = Util.get_first_child_in_group(self, "bow")
		if bow:
			bow.look_at(target.global_position)


#######################################################################33
# nearby items

var nearby_items = []


func _on_ItemPullArea2D_area_entered(area: Area2D):
	nearby_items.append(area)
	print("[player-nearby-items]: ", nearby_items)


func _on_ItemPullArea2D_area_exited(area: Area2D):
	nearby_items.erase(area)
	print("[player-nearby-items]: ", nearby_items)


var move_speed = 400


func pull_items(delta):
	for n in nearby_items:
		if is_instance_valid(n):
			# do i have the thing itself, or a sub-component?
			if n.is_in_group("magnetic"):
				var diff = (n.global_position - global_position).normalized()
				# += here pushes things away
				n.position -= diff * delta * move_speed

			if n.get("owner") and n.owner.is_in_group("magnetic"):
				var diff = (n.owner.global_position - global_position).normalized()
				# += here pushes things away
				n.owner.position -= diff * delta * move_speed
		else:
			nearby_items.erase(n)


#######################################################################33
# health/death

var health = 3
var dead = false


func hit():
	health -= 1
	print("[PLAYER HIT]: remaining health = ", health)

	remove_info_message(health_info_dict(health + 1))
	add_info_message(health_info_dict(health))

	if health <= 0:
		die()
	else:
		# TODO API helper for this whole debug msg thing?
		var msg = {"label": "health -= 1"}
		add_debug_message(msg)
		yield(get_tree().create_timer(2.0), "timeout")
		remove_debug_message(msg)


func die():
	print("[PLAYER DEATH]")
	dead = true
	queue_free()
	# death menu
	Navi.show_death_menu()
	# TODO restart behavior - just this dungeon? load last checkpoint?


func _on_Hurtbox_body_entered(body: Node):
	if (
		body.is_in_group("enemies")
		or (body.get("owner") and body.owner.is_in_group("enemies"))
		or body.is_in_group("enemy_projectile")
	):
		hit()


func health_info_dict(h):
	return {"label": str("Health: ", h)}


#######################################################################33
# debug list

const debug_messages = []

var debug_label_scene = preload("res://src/dungeonCrawler/player/ActionLabel.tscn")
onready var debug_list = $DebugList


func add_debug_message(msg):
	var label_text = msg.get("label")
	if label_text:
		var new_label = debug_label_scene.instance()
		new_label.bbcode_text = "[center]" + label_text
		debug_list.add_child(new_label)
		debug_messages.append(msg)


func remove_debug_message(msg):
	var to_remove
	for debug_label in debug_list.get_children():
		if debug_label.text == msg.get("label"):
			to_remove = debug_label
			break

	if to_remove:
		debug_list.remove_child(to_remove)

	debug_messages.erase(msg)


#######################################################################33
# info panel

const info_messages = []

var info_message_scene = preload("res://src/dungeonCrawler/player/InfoMessage.tscn")
onready var info_list = get_node("%InfoList")


func add_info_message(msg):
	var label_text = msg.get("label")
	if label_text:
		var new_label = info_message_scene.instance()
		new_label.bbcode_text = "[center]" + label_text
		info_list.add_child(new_label)
		info_messages.append(msg)


func remove_info_message(msg):
	var to_remove
	for info_label in info_list.get_children():
		if info_label.text == msg.get("label"):
			to_remove = info_label
			break

	if to_remove:
		info_list.remove_child(to_remove)

	info_messages.erase(msg)
