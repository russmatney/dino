extends KinematicBody2D

onready var anim = $AnimatedSprite

############################################################
# ready

func _ready():
	machine.connect("transitioned", self, "on_transit")

############################################################
# machine

onready var machine = $Machine
onready var state_label = $StateLabel

func on_transit(new_state):
	set_state_label(new_state)

func set_state_label(label: String):
	state_label.bbcode_text = "[center]" + label + "[/center]"

############################################################
# movement

var velocity = Vector2.ZERO
var speed := 100

############################################################
# facing

enum DIR { left, right }
var facing_direction = DIR.left

func face_right():
	facing_direction = DIR.right
	anim.flip_h = true

func face_left():
	facing_direction = DIR.left
	anim.flip_h = false

############################################################
