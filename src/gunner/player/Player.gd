extends KinematicBody2D

onready var anim = $AnimatedSprite
onready var notif_label = $NotifLabel

############################################################
# _ready


func _ready():
	machine.connect("transitioned", self, "on_transit")
	face_left()

	Cam.call_deferred("ensure_camera", 2)
	Gunner.ensure_hud()


############################################################
# _process

var positions = []
var rec_pos_n = 10
var rec_pos_every = 0.0005
var rec_pos_in = 0


func _process(delta):
	move_dir = Trolley.move_dir()

	if rec_pos_in > 0:
		rec_pos_in = rec_pos_in - delta
	else:
		rec_pos_in = rec_pos_every

		positions.push_front(get_global_position())
		if positions.size() > rec_pos_n:
			positions.pop_back()

	var back = positions.back()
	if back:
		var target = back + Vector2(-45, 0)
		var current = state_label.get_global_position()
		var pos = target * 0.1 + current * 0.9
		state_label.set_global_position(pos)


############################################################
# _unhandled_input


func _unhandled_key_input(event):
	if Trolley.is_jump(event):
		if can_wall_jump and is_on_wall():
			machine.transit("Jump")
		if state in ["Idle", "Run", "Fall"]:
			machine.transit("Jump")
	elif Trolley.is_event(event, "action"):
		shine()
	elif Trolley.is_event(event, "fire"):
		fire()
	elif Trolley.is_event_released(event, "fire"):
		stop_firing()

############################################################
# health

var initial_health = 6
onready var health = initial_health

signal health_change(health)

func take_damage(d = 1):
	health -= d
	emit_signal("health_change", health)

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
	state_label.bbcode_text = "[center]" + lbl + "[/center]"


############################################################
# movement

var move_dir = Vector2.ZERO  # controller input
var velocity = Vector2.ZERO
export(int) var speed := 120
export(int) var air_speed := 120
export(int) var jump_impulse := 400
export(int) var gravity := 900

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


func fire_bullet():
	var bullet = bullet_scene.instance()
	bullet.position = bullet_position.get_global_position()
	Navi.current_scene.call_deferred("add_child", bullet)
	bullet.rotation = facing_dir.angle()
	bullet.apply_impulse(Vector2.ZERO, facing_dir * bullet_impulse)
	Gunner.play_sound("fire")

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

	label.bbcode_text = "[center][jump][sparkle freq=10.0 c1=#4466cc c2=#aabbdd]" + text
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
	Gunner.notif("Level Up")

######################################################################
# shine

func shine(time=1.0):
	var tween = create_tween()
	anim.material.set("shader_param/speed", 1.0)
	tween.tween_callback(anim.material, "set", ["shader_param/speed", 0.0]).set_delay(time)
