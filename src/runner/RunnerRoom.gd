tool
extends Node2D
class_name RunnerRoom

var expected_child_nodes = ["RoomBox"]

func _get_configuration_warning():
	for n in ["RoomBox"]:
		var node = find_node(n)
		if not node:
			return "Missing expected child named '" + n + "'"
		if node.name == "RoomBox":
			if node.position.x != 0:
				return "RoomBox Area2d should be at position 0,0"
	return ""

###########################################################
## Runner Room API

# returns the width of the room. uses the RoomBox's collision shape
func room_width():
	# we have use get_node directly here b/c this also runs at editor-time
	var coll_shape = get_node("RoomBox/CollisionShape2D")
	var shape = get_node("RoomBox/CollisionShape2D").shape
	return shape.extents.x * 2 * coll_shape.scale.x

# returns the distance from the furthest left to the origin.
# calculated using the width and the roombox's position
func x_offset():
	# may also want to account for position/scale in the roombox area2d
	var coll_shape = get_node("RoomBox/CollisionShape2D")

	if coll_shape.position.x > 0:
		return abs((room_width() / 2) - coll_shape.position.x * coll_shape.scale.x)
	elif coll_shape.position.x < 0:
		return (room_width() / 2) + abs(coll_shape.position.x * coll_shape.scale.x)
	else:
		return room_width() / 2


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
