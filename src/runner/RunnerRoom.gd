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
	# we have use get_node directly here b/c this also runs at editor-time
	return get_node("RoomBox/CollisionShape2D").shape.extents.x * 2

onready var roombox = $RoomBox

func _ready():
	if Engine.editor_hint:
		request_ready()

	var err
	err = roombox.connect("body_entered", self, "_on_body_entered")
	if err: print("[Error]: ", err)
	err = roombox.connect("body_exited", self, "_on_body_exited")
	if err: print("[Error]: ", err)

var bodies = []

func _on_body_entered(body):
	if body.is_in_group("player"):
		bodies.append(body)
		print("[Room: ", str(self), "] bodies: ", bodies)


func _on_body_exited(body):
	if body.is_in_group("player"):
		bodies.erase(body)
		print("[Room: ", str(self), "] bodies: ", bodies)
