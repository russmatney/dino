tool
extends Node2D


func room_width():
	return get_node("Ground/CollisionShape2D").shape.extents.x * 2 * get_node("Ground").scale.x
