@tool
extends Node2D
class_name WoodsRoom

enum t {NORM, LONG, CLIMB, FALL}

static func room_opts(last_room, last_opts=null, overrides=null):
	if last_opts == null:
		last_opts = {}
	if overrides == null:
		overrides = {}

	var type = overrides.get("type")
	if type == null:
		type = Util.rand_of([t.NORM, t.LONG, t.CLIMB, t.FALL])

	var room_base_dim = overrides.get("room_base_dim", 256)

	var size
	match type:
		t.NORM: size = Vector2.ONE * room_base_dim
		t.CLIMB, t.FALL: size = Vector2.ONE * room_base_dim * Vector2(1, 2)
		t.LONG: size = Vector2.ONE * room_base_dim * Vector2(2, 1)

	var pos
	match type:
		t.NORM, t.FALL, t.LONG: pos = Vector2(
			last_room.position.x + last_room.rect.size.x, last_room.position.y
			)
		t.CLIMB: pos = Vector2(
			last_room.position.x + last_room.rect.size.x,
			last_room.position.y + last_room.rect.size.y - size.y,
			)
	if last_opts and "type" in last_opts:
		match [last_opts.type, type]:
			[t.CLIMB, t.CLIMB]: pos.y -= room_base_dim
			[_, t.CLIMB]: pass
			[t.FALL, _]: pos.y += room_base_dim

	var color
	match type:
		t.NORM: color = Color.PERU
		t.LONG: color = Color.FUCHSIA
		t.FALL: color = Color.CRIMSON
		t.CLIMB: color = Color.AQUAMARINE

	return {position=pos, size=size, type=type, color=color}

var rect

static func create_room(opts) -> WoodsRoom:
	Debug.pr("Creating room", opts)

	var room_base_dim = Util.get_(opts, "room_base_dim", 256)

	var room = WoodsRoom.new()
	room.position = Util.get_(opts, "position", Vector2.ZERO)

	# position should apply to room, not the rect
	var rec = ColorRect.new()
	rec.size = Util.get_(opts, "size", Vector2.ONE * room_base_dim)
	rec.color = Util.get_(opts, "color", Color.PERU)

	room.rect = rec
	room.add_child(rec)

	return room
