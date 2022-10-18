tool
extends Node2D
class_name RunnerRoom

var expected_child_nodes = ["RoomBox"]

func _get_configuration_warning():
	for n in ["RoomBox"]:
		var node = find_node(n)
		if not node:
			return "Missing expected child named '" + n + "'"
	return ""


func room_width():
	return get_node("RoomBox/CollisionShape2D").shape.extents.x * 2


func _ready():
	if Engine.editor_hint:
		request_ready()
