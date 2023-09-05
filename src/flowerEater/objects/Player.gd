@tool
extends Node2D

@export var display_name = "player" :
	set(v):
		display_name = v
		setup()
@export var square_size = 16 :
	set(v):
		square_size = v
		setup()

@onready var label = $ObjectLabel
@onready var color_rect = $ColorRect

func _ready():
	setup()

func setup():
	if label != null:
		label.text = "[center]%s[/center]" % display_name
		label.custom_minimum_size = Vector2.ONE * square_size
	if color_rect != null:
		color_rect.size = Vector2.ONE * square_size
