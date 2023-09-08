@tool
extends Node2D

@export var display_name = "dot"
@export var square_size = 16 :
	set(v):
		square_size = v
		setup()

@export var obj_type: DotHopLevel.type :
	set(v):
		obj_type = v
		setup()

@onready var label = $ObjectLabel
@onready var color_rect = $ColorRect

func _ready():
	setup()

func setup():
	if obj_type == null:
		return

	if label != null:

		match obj_type:
			DotHopLevel.type.Dot: color_rect.color = Color(1, 0, 0)
			DotHopLevel.type.Dotted: color_rect.color = Color(0, 1, 0)
			DotHopLevel.type.Goal: color_rect.color = Color(0, 0, 1)

		label.text = "[center]%s[/center]" % display_name
		label.custom_minimum_size = Vector2.ONE * square_size
	if color_rect != null:
		color_rect.size = Vector2.ONE * square_size

		match obj_type:
			DotHopLevel.type.Dot: color_rect.color = Color(1, 0, 0)
			DotHopLevel.type.Dotted: color_rect.color = Color(0, 1, 0)
			DotHopLevel.type.Goal: color_rect.color = Color(0, 0, 1)

func mark_dotted():
	obj_type = DotHopLevel.type.Dotted

func mark_undotted():
	obj_type = DotHopLevel.type.Dot
