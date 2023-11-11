@tool
extends Node2D
class_name RunnerRoom

var expected_child_nodes = ["RoomBox"]


func _get_configuration_warnings():
	var has_roombox = false
	for n in ["RoomBox"]:
		var node = find_child(n)
		if node:
			has_roombox = true

	if not has_roombox:
		var enter = find_child("EnterBox")
		var exit = find_child("ExitBox")
		if not enter:
			return ["Expected RoomBox or EnterBox"]
		if not exit:
			return ["Found EnterBox, expected ExitBox"]
	return []


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

	Log.pr("[WARN] room_width not supported for room!", self)


func room_width_roombox(coll_shape):
	var shape = get_node("RoomBox/CollisionShape2D").shape
	return shape.extents.x * 2 * coll_shape.scale.x


func room_width_enterbox():
	var enter_coll_shape = get_node("EnterBox/CollisionShape2D")
	var left_x_offset = calc_shape_offset(enter_coll_shape)

	var exit_coll_shape = get_node("ExitBox/CollisionShape2D")
	var right_x_offset = calc_shape_offset(exit_coll_shape, false)

	return right_x_offset - left_x_offset


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

	Log.pr("[WARN] x_offset not supported for room!", self)


func x_offset_roombox(coll_shape):
	return calc_shape_offset(coll_shape)


func x_offset_enterbox(coll_shape):
	return calc_shape_offset(coll_shape)


func calc_shape_offset(coll_shape, left_side = true):
	var coll_x_offset
	if left_side:
		coll_x_offset = (coll_shape.position.x - coll_shape.shape.extents.x) * coll_shape.scale.x
	else:
		coll_x_offset = (coll_shape.position.x + coll_shape.shape.extents.x) * coll_shape.scale.x
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
	Hotel.register(self)
	setup()

	if Engine.is_editor_hint():
		request_ready()

	# useful when debugging room calcs
	# my_print_debug.call_deferred()

func my_print_debug():
	Log.pr("---------------------------------------------")
	Log.pr(name, " debug report")
	Log.pr("room_width(): ", room_width())
	Log.pr("x_offset(): ", x_offset())
	Log.pr("---------------------------------------------")

func hotel_data():
	return {is_finished=is_finished()}

func check_out(data):
	Log.pr(data)


# called in _ready() AND when unfinished rooms are re-added to the view
func setup():
	roombox = get_node_or_null("RoomBox")
	enterbox = get_node_or_null("EnterBox")
	exitbox = get_node_or_null("ExitBox")

	if roombox:
		Util._connect(roombox.body_entered, _on_body_entered)
		Util._connect(roombox.body_exited, _on_body_exited)

	if enterbox:
		Util._connect(enterbox.body_entered, _on_body_entered)
	if exitbox:
		Util._connect(exitbox.body_exited, _on_body_exited)


func cleanup():
	pass


func restart_position():
	if enterbox:
		return enterbox.global_position
	if roombox:
		return roombox.global_position


var player

signal player_entered
signal player_exited


func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player.entered_room(self)
		player_entered.emit(player)


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_exited.emit(player)
		player.exited_room(self)
		player = null
