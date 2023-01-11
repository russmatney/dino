extends KinematicBody2D

onready var anim = $AnimatedSprite

############################################################
# _ready

func _ready():
	machine.connect("transitioned", self, "on_transit")

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
		# pos += (1 - delta) * pos
		state_label.set_global_position(pos)

############################################################
# _unhandled_input

func _unhandled_input(event):
	if Trolley.is_jump(event):
		if can_wall_jump:
			machine.transit("WallJump")
		if state in ["Idle", "Run", "Fall"]:
			machine.transit("Jump")

############################################################
# machine

onready var machine = $Machine
onready var state_label = $StateLabel
var state

func on_transit(new_state):
	state = new_state
	set_state_label(new_state)

func set_state_label(label: String):
	state_label.bbcode_text = "[center]" + label + "[/center]"

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

enum DIR { left, right }
var facing_direction = DIR.left

func update_facing():
	if move_dir.x > 0:
		face_right()
	elif move_dir.x < 0:
		face_left()

func face_right():
	facing_direction = DIR.right
	anim.flip_h = true

func face_left():
	facing_direction = DIR.left
	anim.flip_h = false
