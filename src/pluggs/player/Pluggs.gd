extends CharacterBody2D

@onready var state_label = $StateLabel
@onready var machine = $Machine
@onready var anim = $AnimatedSprite2D


func _ready():
	machine.transitioned.connect(on_transit)


func on_transit(new_state):
	set_state_label(new_state)


func set_state_label(label: String):
	state_label.text = "[center]" + label + "[/center]"


var speed := 300
var drag_speed := 50
var gravity := 4000

############################################################

enum DIR { left, right }
var facing_direction = DIR.left


func face_right():
	facing_direction = DIR.right
	anim.flip_h = true


func face_left():
	facing_direction = DIR.left
	anim.flip_h = false


############################################################


func _on_animation_finished():
	if anim.animation == "from-bucket":
		anim.animation = "idle-standing"
