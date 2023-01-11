extends KinematicBody2D

onready var anim = $AnimatedSprite

############################################################
# _ready

func _ready():
	machine.connect("transitioned", self, "on_transit")

############################################################
# _process

func _process(_delta):
    move_dir = Trolley.move_dir()

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
