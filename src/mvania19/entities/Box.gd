@tool
extends Area2D

@onready var anim = $AnimatedSprite2D

@export var initial_anim = "idle":
	set(val):
		initial_anim = val
		$AnimatedSprite2D.play(val)

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play(initial_anim)
