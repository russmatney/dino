tool
extends Node2D

onready var ground_main = $GroundMain

func room_width():
	return get_node("GroundMain/CollisionShape2D").shape.extents.x * 2 * get_node("GroundMain").scale.x
