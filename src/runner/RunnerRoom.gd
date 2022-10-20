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

###########################################################
## Runner Room API

func room_width():
	# we have use get_node directly here b/c this also runs at editor-time
	var coll_shape = get_node("RoomBox/CollisionShape2D")
	var shape = get_node("RoomBox/CollisionShape2D").shape
	return shape.extents.x * 2 * coll_shape.scale.x

# if false, the room will be requeued until this returns true
func is_finished():
	return true

###########################################################
## impl

onready var roombox = $RoomBox

func _ready():
	Util.ensure_connection(roombox, "body_entered", self, "_on_body_entered")
	Util.ensure_connection(roombox, "body_exited", self, "_on_body_exited")

	if Engine.editor_hint:
		request_ready()

var player

signal player_entered
signal player_exited

func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body
		emit_signal("player_entered", player)

func _on_body_exited(body):
	if body.is_in_group("player"):
		player = null
		emit_signal("player_exited", player)
