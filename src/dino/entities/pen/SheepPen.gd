@tool
extends Area2D

@onready var coll: CollisionShape2D = $CollisionShape2D

func _enter_tree():
	add_to_group("pen", true)

func _ready():
	add_color_rect(coll)

func add_color_rect(coll_shape):
	for ch in get_children():
		if ch is ColorRect:
			ch.free()

	if not coll_shape:
		return

	var shape_rect = coll_shape.shape.get_rect()
	var color_rect = ColorRect.new()

	color_rect.position = shape_rect.position + coll.position
	color_rect.size = shape_rect.size
	color_rect.color = Color(.5, .8, .5, 0.4)

	add_child(color_rect)
	color_rect.set_owner(self)
