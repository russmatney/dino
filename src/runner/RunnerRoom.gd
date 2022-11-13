tool
extends Node2D
class_name RunnerRoom

var expected_child_nodes = ["RoomBox"]

func _get_configuration_warning():
	var has_roombox = false
	for n in ["RoomBox"]:
		var node = find_node(n)
		# if not node:
		# 	return "Missing expected child named '" + n + "'"
		if node:
			has_roombox = true
		# if node.name == "RoomBox":
		# 	if node.position.x != 0:
		# 		return "RoomBox Area2d should be at position 0,0"

	if not has_roombox:
		var enter = find_node("EnterBox")
		var exit = find_node("ExitBox")
		if not enter:
			return "Expected RoomBox or EnterBox"
		if not exit:
			return "Found EnterBox, expected ExitBox"
	return ""

###########################################################
## Runner Room room_width

# returns the width of the room. uses the RoomBox's collision shape
func room_width():
	# we have use get_node directly here b/c this also runs at editor-time
	var roombox_coll_shape = get_node_or_null("RoomBox/CollisionShape2D")
	if roombox_coll_shape:
		return room_width_roombox(roombox_coll_shape)

	var enterbox_shape = get_node_or_null("EnterBox/CollisionShape2D")
	if enterbox_shape:
		return room_width_enterbox()

	print("[WARN] room_width not supported for room!", self)

func room_width_roombox(coll_shape):
	var shape = get_node("RoomBox/CollisionShape2D").shape
	return shape.extents.x * 2 * coll_shape.scale.x

func room_width_enterbox():
	# TODO maybe need to incorporate parent (area2d) position + scale as well
	var enter_coll_shape = get_node("EnterBox/CollisionShape2D")
	var left_x_offset = abs((enter_coll_shape.position.x + enter_coll_shape.shape.extents.x) * enter_coll_shape.scale.x)

	var exit_coll_shape = get_node("ExitBox/CollisionShape2D")
	var right_x_offset = abs((exit_coll_shape.position.x + exit_coll_shape.shape.extents.x) * enter_coll_shape.scale.x)

	return left_x_offset + right_x_offset

###########################################################
## Runner Room x_offset

# returns the distance from the furthest left to the origin.
# calculated using the width and the roombox's position
func x_offset():
	# may also want to account for position/scale in the roombox area2d
	var roombox_coll_shape = get_node_or_null("RoomBox/CollisionShape2D")

	if roombox_coll_shape:
		return x_offset_roombox(roombox_coll_shape)

	var enterbox_shape = get_node_or_null("EnterBox/CollisionShape2D")
	if enterbox_shape:
		return x_offset_enterbox(enterbox_shape)

	print("[WARN] x_offset not supported for room!", self)

func x_offset_roombox(coll_shape):
	# note requires roombox area2d to have 0, 0 position :/
	if coll_shape.position.x > 0:
		return abs((room_width() / 2) - coll_shape.position.x * coll_shape.scale.x)
	elif coll_shape.position.x < 0:
		return (room_width() / 2) + abs(coll_shape.position.x * coll_shape.scale.x)
	else:
		return room_width() / 2

func x_offset_enterbox(coll_shape):
	var coll_x_offset = (coll_shape.position.x - coll_shape.shape.extents.x) * coll_shape.scale.x
	var p = coll_shape.get_parent()
	var parent_x_offset = p.position.x * p.scale.x
	return coll_x_offset + parent_x_offset

###########################################################
## Runner Room is_finished()

# if false, the room will be requeued until this returns true
func is_finished():
	return true

###########################################################
## impl

var roombox
var enterbox
var exitbox

func _ready():
	setup()

	if Engine.editor_hint:
		request_ready()

	call_deferred("print_debug")

func print_debug():
	print("---------------------------------------------")
	print(self.name, " debug report")
	print("room_width(): ", room_width())
	print("x_offset(): ", x_offset())
	print("---------------------------------------------")

func setup():
	roombox = get_node_or_null("RoomBox")
	enterbox = get_node_or_null("EnterBox")
	exitbox = get_node_or_null("ExitBox")

	if roombox:
		Util.ensure_connection(roombox, "body_entered", self, "_on_body_entered")
		Util.ensure_connection(roombox, "body_exited", self, "_on_body_exited")

	if enterbox:
		Util.ensure_connection(enterbox, "body_entered", self, "_on_body_entered")
	if exitbox:
		Util.ensure_connection(exitbox, "body_exited", self, "_on_body_exited")

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
