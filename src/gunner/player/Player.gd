extends KinematicBody2D

onready var anim = $AnimatedSprite

############################################################
# _ready

func _ready():
	machine.connect("transitioned", self, "on_transit")

	face_left()

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
		var pos = target - (current - target) * 0.1
		state_label.set_global_position(pos)

############################################################
# _unhandled_input

func _unhandled_key_input(event):
	if Trolley.is_jump(event):
		if can_wall_jump:
			machine.transit("Jump")
		if state in ["Idle", "Run", "Fall"]:
			machine.transit("Jump")
	elif Trolley.is_event(event, "fire"):
		fire()
	elif Trolley.is_event_released(event, "fire"):
		stop_firing()

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

var move_dir = Vector2.ZERO # controller input
var velocity = Vector2.ZERO
export(int) var speed := 120
export(int) var air_speed := 120
export(int) var jump_impulse := 400
export(int) var gravity := 900

var can_wall_jump

############################################################
# facing

var facing_dir = Vector2.ZERO

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

func face_left():
	facing_dir = Vector2(-1, 0)
	anim.flip_h = false

	if bullet_position.position.x > 0:
		bullet_position.position.x *= -1

############################################################
# fire

onready var bullet_position = $BulletPosition
var firing = false

# per-bullet (gun) numbers

onready var bullet_scene = preload("res://src/gunner/weapons/Bullet.tscn")
var bullet_impulse = 800
var fire_rate = 0.2
var bullet_knockback = 2

var tween
func fire():
	firing = true

	if tween and tween.is_running():
		return

	tween = create_tween()
	fire_bullet()
	tween.set_loops(0)
	tween.tween_callback(self, "fire_bullet").set_delay(fire_rate)

func stop_firing():
	firing = false

	# kill tween after last bullet
	if tween and tween.is_running():
		tween.kill()

func fire_bullet():
	var bullet = bullet_scene.instance()
	bullet.position = bullet_position.get_global_position()
	Navi.current_scene.call_deferred("add_child", bullet)
	bullet.rotation = facing_dir.angle()
	bullet.apply_impulse(Vector2.ZERO, facing_dir * bullet_impulse)

	# push player back when firing
	var pos = get_global_position()
	pos += -1 * facing_dir * bullet_knockback
	set_global_position(pos)
