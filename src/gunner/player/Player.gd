extends KinematicBody2D

onready var anim = $AnimatedSprite
onready var jet_anim = $Jet
onready var notif_label = $NotifLabel

var dead = false

############################################################
# _ready


var reset_position

export(bool) var has_jetpack = false

func _ready():
	reset_position = get_global_position()
	machine.connect("transitioned", self, "on_transit")
	face_left()

	Cam.call_deferred("ensure_camera", 2)
	Hood.ensure_hud()

############################################################
# _process

var positions = []
var record_pos_n = 10
var record_pos_every = 0.0005
var record_pos_in = 0

export(float) var max_y = 10000.0

func _process(delta):
	move_dir = Trolley.move_dir()

	if record_pos_in > 0:
		record_pos_in = record_pos_in - delta
	else:
		record_pos_in = record_pos_every

		positions.push_front(get_global_position())
		if positions.size() > record_pos_n:
			positions.pop_back()

	var back = positions.back()
	if back:
		var target = back + Vector2(-45, 0)
		var current = state_label.get_global_position()
		var pos = target * 0.1 + current * 0.9
		state_label.set_global_position(pos)

	# TODO remove/replace with some other thing?
	if get_global_position().y >= max_y:
		take_damage(null, 1)
		position = reset_position
		velocity = Vector2.ZERO

############################################################
# _unhandled_input

var jump_count = 0

func _unhandled_key_input(event):
	if not dead and has_jetpack and Trolley.is_event(event, "jetpack"):
		machine.transit("Jetpack")
	elif not dead and Trolley.is_jump(event):
		if can_wall_jump and is_on_wall():
			machine.transit("Jump")
		if state in ["Idle", "Run", "Fall"] and jump_count == 0:
			machine.transit("Jump")
	elif not dead and Trolley.is_event(event, "action"):
		shine()
	elif not dead and Trolley.is_event(event, "fire") and not state in ["Knockback"]:
		fire()
	elif Trolley.is_event_released(event, "fire"):
		stop_firing()

############################################################
# health

var initial_health = 6
onready var health = initial_health

signal health_change(health)
signal dead

func take_damage(body=null, d = 1):
	health -= d
	emit_signal("health_change", health)

	var dir
	if body:
		if body.global_position.x > global_position.x:
			dir = Vector2.LEFT
		else:
			dir = Vector2.RIGHT
		machine.transit("Knockback", {"dir": dir, "dead": health <= 0})
	else:
		machine.transit("Dead", {"shake": 1.0})

func die(remove=false):
	dead = true
	emit_signal("dead")
	if remove:
		queue_free()

############################################################
# machine

onready var machine = $Machine
onready var state_label = $StateLabel
var state


func on_transit(new_state):
	state = new_state
	set_state_label(new_state)


func set_state_label(label: String):
	var lbl = label
	if machine.state.has_method("label"):
		lbl = machine.state.label()
	if in_blue:
		lbl += " COLD"
	if in_red:
		lbl += " HOT"
	state_label.bbcode_text = "[center]" + lbl + "[/center]"


############################################################
# movement

var move_dir = Vector2.ZERO  # controller input
var velocity = Vector2.ZERO
export(int) var speed := 220
export(int) var air_speed := 200
export(int) var max_fall_speed := 1500
export(int) var jump_impulse := 400
export(int) var gravity := 900
export(int) var jetpack_boost := 800
export(int) var max_jet_speed := -1200

var can_wall_jump

############################################################
# facing

var facing_dir = Vector2.ZERO
onready var look_pof = $LookPOF


func update_facing():
	if move_dir.x > 0:
		face_right()
	elif move_dir.x < 0:
		face_left()


func face_right():
	facing_dir = Vector2(1, 0)
	anim.flip_h = true

	if bullet_position.position.x < 0:
		bullet_position.position.x *= -1

	if look_pof.position.x < 0:
		look_pof.position.x *= -1


func face_left():
	facing_dir = Vector2(-1, 0)
	anim.flip_h = false

	if bullet_position.position.x > 0:
		bullet_position.position.x *= -1

	if look_pof.position.x > 0:
		look_pof.position.x *= -1


############################################################
# fire

onready var bullet_position = $BulletPosition
var firing = false

# per-bullet (gun) numbers

onready var bullet_scene = preload("res://src/gunner/weapons/Bullet.tscn")
var bullet_impulse = 800
var fire_rate = 0.2
var bullet_knockback = 2

var fire_tween


func fire():
	firing = true

	if fire_tween and fire_tween.is_running():
		return

	fire_tween = create_tween()
	fire_bullet()
	fire_tween.set_loops(0)
	fire_tween.tween_callback(self, "fire_bullet").set_delay(fire_rate)


func stop_firing():
	firing = false

	# kill tween after last bullet
	if fire_tween and fire_tween.is_running():
		fire_tween.kill()

signal fired_bullet(bullet)

func fire_bullet():
	var bullet = bullet_scene.instance()
	bullet.position = bullet_position.get_global_position()
	bullet.add_collision_exception_with(self)
	Navi.current_scene.call_deferred("add_child", bullet)
	bullet.rotation = facing_dir.angle()
	bullet.apply_impulse(Vector2.ZERO, facing_dir * bullet_impulse)
	GunnerSounds.play_sound("fire")
	emit_signal("fired_bullet", bullet)

	# push player back when firing
	var pos = get_global_position()
	pos += -1 * facing_dir * bullet_knockback
	set_global_position(pos)

######################################################################
# notif

func notif(text, opts={}):
	var ttl = opts.get("ttl", 1.5)
	var dupe = opts.get("dupe", false)
	var label
	if dupe:
		label = notif_label.duplicate()
	else:
		label = notif_label

	label.bbcode_text = "[center][jump][sparkle freq=10.0 c1=#5b768d c2=#f6c6a8]" + text
	label.set_visible(true)
	var tween = create_tween()

	if dupe:
		label.set_global_position(notif_label.get_global_position())
		Navi.add_child_to_current(label)
		tween.tween_callback(label, "queue_free").set_delay(ttl)
	else:
		tween.tween_callback(label, "set_visible", [false]).set_delay(ttl)

######################################################################
# level up

func level_up():
	shine(2.0)
	notif("LEVEL UP", {"dupe": true})
	Hood.notif("Level Up")

######################################################################
# shine

func shine(time=1.0):
	var tween = create_tween()
	anim.material.set("shader_param/speed", 1.0)
	tween.tween_callback(anim.material, "set", ["shader_param/speed", 0.0]).set_delay(time)

######################################################################
# pickups

var pickups = []

signal pickups_changed(pickups)

func collect_pickup(pickup_type):
	notif(pickup_type.capitalize() + " PICKED UP", {"dupe": true})
	if pickup_type == "jetpack":
		has_jetpack = true
	else:
		pickups.append(pickup_type)
		emit_signal("pickups_changed", pickups)

######################################################################
# tile color detection

var current_tile_colors = []

func _on_TileAOEDetector_body_entered(body:Node):
	if body.is_in_group("yellowtile"):
		current_tile_colors.append("yellow")
	elif body.is_in_group("bluetile"):
		current_tile_colors.append("blue")
	elif body.is_in_group("redtile"):
		current_tile_colors.append("red")
	update_colors()
	update_aoe_state()

func _on_TileAOEDetector_body_exited(body:Node):
	if body.is_in_group("yellowtile"):
		current_tile_colors.erase("yellow")
	elif body.is_in_group("bluetile"):
		current_tile_colors.erase("blue")
	elif body.is_in_group("redtile"):
		current_tile_colors.erase("red")
	update_colors()
	update_aoe_state()

var coldfire_dark = Color8(70, 66, 94)
var coldfire_blue = Color8(91, 118, 141)
var coldfire_red = Color8(209, 124, 124)
var coldfire_yellow = Color8(246, 198, 168)

func update_colors():
	var tween = create_tween()
	if current_tile_colors:
		var color = current_tile_colors[0]

		match(color):
			"red":
				tween.tween_property(anim.material, "shader_param/outline", coldfire_dark, 0.4)
				tween.parallel().tween_property(anim.material, "shader_param/accent", coldfire_yellow, 0.4)
			"yellow":
				tween.tween_property(anim.material, "shader_param/outline", coldfire_dark, 0.4)
				tween.parallel().tween_property(anim.material, "shader_param/accent", coldfire_red, 0.4)
			"blue":
				tween.tween_property(anim.material, "shader_param/outline", coldfire_yellow, 0.4)
				tween.parallel().tween_property(anim.material, "shader_param/accent", coldfire_dark, 0.4)
	else:
		tween.tween_property(anim.material, "shader_param/outline", coldfire_dark, 0.4)
		tween.parallel().tween_property(anim.material, "shader_param/accent", coldfire_yellow, 0.4)

var in_blue = false
var in_red = false
func update_aoe_state():
	if "blue" in current_tile_colors:
		in_blue = true
	else:
		in_blue = false

	if "red" in current_tile_colors:
		in_red = true
	else:
		in_red = false
