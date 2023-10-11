extends CharacterBody2D

## vars ######################################################

@onready var state_label = $StateLabel
@onready var machine = $Machine
@onready var anim = $AnimatedSprite2D

@export var speed := 300
@export var drag_speed := 50
@export var gravity := 4000

## ready ######################################################

func _ready():
	machine.transitioned.connect(on_transit)
	machine.start()

	Cam.ensure_camera({
		player=self,
		zoom_rect_min=250,
		proximity_min=50,
		proximity_max=250,
		})

## transitions ######################################################

func on_transit(new_state):
	set_state_label(new_state)

func set_state_label(label: String):
	state_label.text = "[center]" + label + "[/center]"

func _on_animation_finished():
	if anim.animation == "from-bucket":
		anim.play("idle-standing")

## facing ##########################################################

enum DIR { left, right }
var facing_direction = DIR.left

func face_right():
	facing_direction = DIR.right
	anim.flip_h = false

func face_left():
	facing_direction = DIR.left
	anim.flip_h = true
