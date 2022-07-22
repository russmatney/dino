extends KinematicBody2D

var velocity := Vector2.ZERO

export(int) var jump_impulse := 1000
export(int) var speed := 500
export(int) var gravity := 2000

var initial_pos

onready var state_label = $StateLabel
onready var machine = $Machine


func _ready():
	initial_pos = get_global_position()
	machine.connect("transitioned", self, "on_transit")


func on_transit(new_state):
	set_state_label(new_state)


func _process(_delta):
	if get_global_position().y > 30000:
		position = initial_pos
		velocity = Vector2.ZERO


func set_state_label(label: String):
	state_label.bbcode_text = "[center]" + label + "[/center]"
