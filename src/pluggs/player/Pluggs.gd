extends KinematicBody2D

onready var state_label = $StateLabel
onready var machine = $Machine
onready var anim = $AnimatedSprite

func _ready():
	machine.connect("transitioned", self, "on_transit")

func on_transit(new_state):
	set_state_label(new_state)

func set_state_label(label: String):
	state_label.bbcode_text = "[center]" + label + "[/center]"

var velocity = Vector2.ZERO
var speed := 300
var gravity := 4000
