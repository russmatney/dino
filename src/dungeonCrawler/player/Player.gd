extends CharacterBody2D
class_name Player

@onready var action_hint = $ActionHint
@onready var action_detector = $ActionDetector

#######################################################################
# ready

var initial_pos

func hotel_data():
	return {coins=coins, health=health, items=items}

func check_out(data):
	coins = data.get("coins", coins)
	health = data.get("health", health)
	items = data.get("items", items)

func _ready():
	Hotel.register(self)

	Cam.request_camera({player=self})
	Hood.ensure_hud()
	action_detector.setup(self, {action_hint=action_hint})

	initial_pos = get_global_position()
	anim.flip_h = facing == facing_dir.RIGHT

	setup.call_deferred()


func setup():
	add_info_message(health_info_dict(health))


#######################################################################
# facing

@onready var anim = $AnimatedSprite2D
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


#######################################################################
# process

var move_accel := 800
var max_speed := 300

func _process(delta):
	var move_dir = Trolley.move_vector()
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
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity

	point_at_target()

	pull_items(delta)


#######################################################################
# _input


func _unhandled_input(event):
	if Trolley.is_action(event):
		var executed = action_detector.execute_current_action()

		if not executed and weapon:
			# one button for everything?
			use_weapon(weapon)

	if Trolley.is_attack(event):
		if weapon:
			use_weapon(weapon)


#######################################################################
# weapons

@onready var weapon_pos = $WeaponPosition
var weapon


func update_weapon():
	if weapons.size() > 0:
		weapon = weapons[0]
	else:
		weapon = null

	if not weapon == null:
		match weapon["type"]:
			"bow":
				attach_bow()


func use_weapon(wp = null):
	if wp == null:
		wp = weapon

	match wp["type"]:
		"bow":
			fire_bow()


func point_weapon(dir):
	if not weapon == null:
		match weapon["type"]:
			"bow":
				point_bow(dir)


var weapons = []


func add_weapon(wp):
	weapons.append(wp)
	Debug.pr("[player weapons]: ", weapons)

	update_weapon()


func remove_weapon(wp):
	weapons.erase(wp)
	Debug.pr("[player weapons]: ", weapons)


# bow

var player_bow_scene = preload("res://src/dungeonCrawler/weapons/BowWeapon.tscn")


func attach_bow():
	var bow = player_bow_scene.instantiate()
	add_child.call_deferred(bow)
	bow.transform.origin = weapon_pos.position


var arrow_scene = preload("res://src/dungeonCrawler/weapons/ArrowProjectile.tscn")
var arrow_impulse = 400


func fire_bow():
	var bow = Util.get_first_child_in_group(self, "bow")
	if bow == null:
		Debug.pr("[WARN]: attempted to fire bow, but no bow found (expected node group 'bow')")
		return

	var arrow = arrow_scene.instantiate()
	arrow.position = bow.get_global_position()  # maybe use weapon position?
	# prefer to add bullets to the current scene, so they get cleaned up
	Navi.add_child_to_current(arrow)
	arrow.rotation_degrees = bow.rotation_degrees + 90
	var impulse_dir = Vector2(1, 0).rotated(deg_to_rad(bow.rotation_degrees))
	arrow.apply_impulse(impulse_dir * arrow_impulse, Vector2.ZERO)


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


#######################################################################
# coins

var coins = 0


func add_coin():
	coins += 1
	Hotel.check_in(self)

	remove_info_message(coin_info_dict(coins - 1))
	add_info_message(coin_info_dict(coins))


func coin_info_dict(c):
	return {"label": str("Coins: ", c)}


#######################################################################
# items

var items = []


func add_item(it):
	items.append(it)
	Debug.pr("[player items]: ", items)
	update_item_info()


func remove_item(it):
	items.erase(it)
	Debug.pr("[player items]: ", items)
	update_item_info()


func update_item_info():
	Hotel.check_in(self)
	var key_ct = 0
	for it in items:
		if it.get("type") == "key":
			key_ct += 1

	remove_info_message({"label": str("Keys: ", 1)})
	remove_info_message({"label": str("Keys: ", 2)})
	if key_ct > 0:
		add_info_message({"label": str("Keys: ", key_ct)})


#######################################################################
# doors/keys


func can_lock_door():
	return false


func can_unlock_door():
	for it in items:
		if it["type"] == "key":
			return true
	return false


func use_key():
	var key_item
	for it in items:
		if it["type"] == "key":
			key_item = it

	if key_item:
		remove_item(key_item)


#######################################################################
# targets
# can pretty much lock-checked to everything

var bodies = []


func _on_LockOnDetectArea2D_body_entered(body: Node):
	if body != self and body.name != "DungeonWalls":
		bodies.append(body)
		# Debug.pr("[player-lockon-bodies]:", bodies)


func _on_LockOnDetectArea2D_body_exited(body: Node):
	bodies.erase(body)
	# Debug.pr("[player-lockon-bodies]:", bodies)


var areas = []


func _on_LockOnDetectArea2D_area_entered(area: Area2D):
	areas.append(area)
	# Debug.pr("[player-lockon-areas]:", areas)


func _on_LockOnDetectArea2D_area_exited(area: Area2D):
	areas.erase(area)
	# Debug.pr("[player-lockon-areas]:", areas)


@onready var line_of_sight = $LineOfSightRayCast2D


func in_line_of_sight(body):
	var cast_to = to_local(body.global_position)
	line_of_sight.target_position = cast_to
	line_of_sight.force_raycast_update()
	if line_of_sight.is_colliding():
		var collider = line_of_sight.get_collider()
		if collider == body:
			return true
	return false


var targets = []


func current_target():
	if bodies.size():
		for body in bodies:
			if in_line_of_sight(body) and not body.get("dead"):
				return body
	if areas.size():
		return areas[0]


func point_at_target():
	var target = current_target()
	if target:
		var bow = Util.get_first_child_in_group(self, "bow")
		if bow:
			bow.look_at(target.global_position)


######################################################################
# nearby items

var nearby_items = []


func _on_ItemPullArea2D_area_entered(area: Area2D):
	nearby_items.append(area)
	# Debug.pr("[player-nearby-items]: ", nearby_items)


func _on_ItemPullArea2D_area_exited(area: Area2D):
	nearby_items.erase(area)
	# Debug.pr("[player-nearby-items]: ", nearby_items)


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


#######################################################################
# health/death

var health = 3
var dead = false


func hit():
	health -= 1
	Debug.pr("[PLAYER HIT]: remaining health = ", health)
	Hotel.check_in(self)

	remove_info_message(health_info_dict(health + 1))
	add_info_message(health_info_dict(health))

	if health <= 0:
		die()
	else:
		var msg = {"label": "health -= 1"}
		add_debug_message(msg)
		await get_tree().create_timer(2.0).timeout
		remove_debug_message(msg)


func die():
	Debug.pr("[PLAYER DEATH]")
	dead = true
	queue_free()
	# death menu
	Navi.show_death_menu()


func _on_Hurtbox_body_entered(body: Node):
	if (
		body.is_in_group("enemies")
		or (body.get("owner") and body.owner.is_in_group("enemies"))
		or body.is_in_group("enemy_projectile")
	):
		hit()


func health_info_dict(h):
	return {"label": str("Health: ", h)}


#######################################################################
# debug list

var debug_messages = []

var debug_label_scene = preload("res://src/dungeonCrawler/player/ActionLabel.tscn")
@onready var debug_list = $DebugList


func add_debug_message(msg):
	var label_text = msg.get("label")
	if label_text:
		var new_label = debug_label_scene.instantiate()
		new_label.text = "[center]" + label_text
		debug_list.add_child(new_label)
		debug_messages.append(msg)


func remove_debug_message(msg):
	var to_remove
	for debug_label in debug_list.get_children():
		if debug_label.get_parsed_text() == msg.get("label"):
			to_remove = debug_label
			break

	if to_remove:
		debug_list.remove_child(to_remove)
		to_remove.queue_free()

	debug_messages.erase(msg)


#######################################################################
# info panel

var info_messages = []

var info_message_scene = preload("res://src/dungeonCrawler/player/InfoMessage.tscn")
@onready var info_list = get_node("%InfoList")


func add_info_message(msg):
	var label_text = msg.get("label")
	if label_text:
		var new_label = info_message_scene.instantiate()
		new_label.text = "[center]" + label_text
		info_list.add_child(new_label)
		info_messages.append(msg)


func remove_info_message(msg):
	var to_remove
	for info_label in info_list.get_children():
		if info_label.get_parsed_text() == msg.get("label"):
			to_remove = info_label
			break

	if to_remove:
		info_list.remove_child(to_remove)
		to_remove.queue_free()

	info_messages.erase(msg)
