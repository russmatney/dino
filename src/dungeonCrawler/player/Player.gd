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

#######################################################################33
# facing

onready var anim = $AnimatedSprite
enum facing_dir {RIGHT, DOWN, LEFT, UP}
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
	velocity = move_and_slide(velocity)

#######################################################################33
# _input

func _unhandled_input(event):
	if Trolley.is_action(event):
		if actions:
			# TODO select an action
			var ax = actions[0]
			execute_action(ax)

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

func use_weapon(wp=null):
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
	arrow.position = bow.get_global_position() # maybe use weapon position?
	# prefer to add bullets to the current scene, so they get cleaned up
	Navi.current_scene.call_deferred("add_child", arrow)
	var impulse_dir = Vector2(1, 0)
	match facing:
		facing_dir.RIGHT:
			arrow.rotation_degrees = 90
			impulse_dir = Vector2(1, 0)
		facing_dir.LEFT:
			arrow.rotation_degrees = -90
			impulse_dir = Vector2(-1, 0)
		facing_dir.UP:
			arrow.rotation_degrees = 0
			impulse_dir = Vector2(0, -1)
		facing_dir.DOWN:
			arrow.rotation_degrees = 180
			impulse_dir = Vector2(0, 1)
	arrow.apply_impulse(Vector2.ZERO, impulse_dir * arrow_impulse)

func point_bow(dir):
	var bow = Util.get_first_child_in_group(self, "bow")
	if bow:
		match dir:
			facing_dir.RIGHT:
				bow.transform.origin = weapon_pos.position
				bow.rotation_degrees = 0
			facing_dir.LEFT:
				bow.transform.origin = Vector2(-weapon_pos.position.x, weapon_pos.position.y)
				bow.rotation_degrees = 180
			facing_dir.UP:
				bow.transform.origin = Vector2(0, -weapon_pos.position.x + weapon_pos.position.y)
				bow.rotation_degrees = -90
			facing_dir.DOWN:
				bow.transform.origin = Vector2(0, weapon_pos.position.x + weapon_pos.position.y)
				bow.rotation_degrees = 90

#######################################################################33
# coins

var coins = 0

func add_coin():
	coins += 1

#######################################################################33
# items

const items = []

func add_item(it):
	items.append(it)
	print("[player items]: ", items)

func remove_item(it):
	items.erase(it)
	print("[player items]: ", items)

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
		items.erase(key_item)

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
