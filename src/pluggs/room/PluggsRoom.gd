@tool
extends Node2D
class_name PluggsRoom

var def: Dictionary # a room def (TODO consider proper type)
var rect: ColorRect

##########################################################################
## static ##################################################################

static func width(room: PluggsRoom, opts: Dictionary):
	return len(room.def.shape[0]) * opts.tile_size

static func size(room: PluggsRoom, opts: Dictionary):
	var y = len(room.def.shape) * opts.tile_size
	var x = len(room.def.shape[0]) * opts.tile_size
	return Vector2(x, y)

static func add_rect(room: PluggsRoom, opts: Dictionary):
	var rec = ColorRect.new()
	rec.name = "ColorRect"
	rec.size = Util.get_(opts, "size", PluggsRoom.size(room, opts))
	rec.color = Util.get_(opts, "color", Color.PERU)
	# rec.visible = opts.get("show_color_rect", false)

	room.rect = rec
	room.add_child(rec)

## room gen ##################################################################

static func gen_room_def(opts={}):
	var parsed_rooms_def = RoomParser.parse_room_defs(opts)
	var room_defs = parsed_rooms_def.rooms

	if opts.get("filter_rooms"):
		room_defs = room_defs.filter(opts.filter_rooms)

	return Util.rand_of(room_defs)

## create room ##################################################################

static func next_room_position(opts: Dictionary, _room, last_room):
	var x = last_room.position.x + PluggsRoom.width(last_room, opts)

	# TODO move up/down based on last_room and room def?
	var y = last_room.position.y
	return Vector2(x, y)

static func create_room(opts, last_room=null):
	Util.ensure_default(opts, "tile_size", 16)

	var room = PluggsRoom.new()
	room.def = gen_room_def(opts)
	room.name = room.def.get("name", "PluggsRoom")
	room.position = Vector2.ZERO if last_room == null else PluggsRoom.next_room_position(opts, room, last_room)

	add_rect(room, opts)

	return room
