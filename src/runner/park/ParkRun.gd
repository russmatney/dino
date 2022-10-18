tool
extends Node2D

onready var ground = $Ground

func room_width():
	print(get_node("Ground/CollisionShape2D"))
	print(get_node("Ground/CollisionShape2D").shape)
	print(get_node("Ground/CollisionShape2D").shape.extents)
	print(scale)
	return get_node("Ground/CollisionShape2D").shape.extents.x * 2 * get_node("Ground").scale.x
