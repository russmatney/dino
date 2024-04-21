@tool
extends Resource
class_name RoomEffect

## vars ##################################

@export var scene: PackedScene

## init ##################################

func _init(opts={}):
	if opts.get("scene"):
		scene = opts.get("scene")

## add at cell ##################################

func add_at_cell(node, rect: Rect2):
	var effect = scene.instantiate()

	var half_x_size = rect.size.x / 2
	var rect_top_center = rect.position + Vector2.RIGHT * half_x_size

	effect.position = rect_top_center
	effect.process_material.emission_box_extents.x = half_x_size

	node.add_child(effect)
	effect.set_owner(node)
