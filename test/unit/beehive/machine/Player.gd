extends CharacterBody2D

@export var jump_impulse: int := 1000
@export var speed: int := 500
@export var gravity: int := 2000

var initial_pos

@onready var state_label = $StateLabel
@onready var machine = $Machine


func _ready():
	print("machine player ready")
	initial_pos = get_global_position()
	machine.connect("transitioned",Callable(self,"on_transit"))


func on_transit(new_state):
	set_state_label(new_state)


func _process(_delta):
	if get_global_position().y > 30000:
		position = initial_pos
		velocity = Vector2.ZERO


func set_state_label(label: String):
	state_label.text = "[center]" + label + "[/center]"
