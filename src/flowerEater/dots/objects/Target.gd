@tool
extends Node2D

@export var display_name = "target"
@export var square_size = 16 :
	set(v):
		square_size = v
		setup()

@export var obj_type: FlowerEaterLevel.type :
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
			FlowerEaterLevel.type.Flower: color_rect.color = Color(1, 0, 0)
			FlowerEaterLevel.type.FlowerEaten: color_rect.color = Color(0, 1, 0)
			FlowerEaterLevel.type.Target: color_rect.color = Color(0, 0, 1)

		label.text = "[center]%s[/center]" % display_name
		label.custom_minimum_size = Vector2.ONE * square_size
	if color_rect != null:
		color_rect.size = Vector2.ONE * square_size

		match obj_type:
			FlowerEaterLevel.type.Flower: color_rect.color = Color(1, 0, 0)
			FlowerEaterLevel.type.FlowerEaten: color_rect.color = Color(0, 1, 0)
			FlowerEaterLevel.type.Target: color_rect.color = Color(0, 0, 1)

func eaten():
	obj_type = FlowerEaterLevel.type.FlowerEaten

func uneaten():
	obj_type = FlowerEaterLevel.type.Flower
