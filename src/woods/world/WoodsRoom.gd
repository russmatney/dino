@tool
extends Node2D
class_name WoodsRoom

## vars, data ##################################################################

enum t {START, END, SQUARE, LONG, CLIMB, FALL}

var rect
var room_def
var tilemap

## room parse ##################################################################

static var parsed_room_defs = {}

static func parse_room_defs():
	# if parsed_room_defs != null and len(parsed_room_defs) > 0:
	# 	Debug.warn("skipping parsed_room_defs parse")
	# 	return parsed_room_defs

	var path = "res://src/woods/world/rooms.txt"
	var file = FileAccess.open(path, FileAccess.READ)
	var contents = file.get_as_text()

	parsed_room_defs = RoomParser.parse(contents)
	return parsed_room_defs

static func room_for_type(type):
	var rooms_by_type = {}
	parse_room_defs()
	for room in parsed_room_defs.rooms:
		var rms = Util.get_(rooms_by_type, room.room_type, [])
		rms.append(room)
		rooms_by_type[room.room_type] = rms

	var type_s
	match type:
		t.START: type_s = "START"
		t.END: type_s = "END"
		t.SQUARE: type_s = "SQUARE"
		t.CLIMB: type_s = "CLIMB"
		t.FALL: type_s = "FALL"
		t.LONG: type_s = "LONG"

	return Util.rand_of(rooms_by_type[type_s])

## room_opts ##################################################################

static func room_opts(last_room, last_opts=null, overrides=null):
	if last_opts == null:
		last_opts = {}
	if overrides == null:
		overrides = {}

	var type = overrides.get("type")
	if type == null:
		type = Util.rand_of([t.SQUARE, t.LONG, t.CLIMB, t.FALL])

	var room_base_dim = overrides.get("room_base_dim", 256)

	var size
	match type:
		t.SQUARE, t.START, t.END: size = Vector2.ONE * room_base_dim
		t.CLIMB, t.FALL: size = Vector2.ONE * room_base_dim * Vector2(1, 2)
		t.LONG: size = Vector2.ONE * room_base_dim * Vector2(2, 1)

	var pos
	match type:
		t.START, t.END, t.SQUARE, t.FALL, t.LONG: pos = Vector2(
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
		t.SQUARE, t.START, t.END: color = Color.PERU
		t.LONG: color = Color.FUCHSIA
		t.FALL: color = Color.CRIMSON
		t.CLIMB: color = Color.AQUAMARINE

	return {position=pos, size=size, type=type, color=color}

static var tmap_scene = preload("res://addons/reptile/tilemaps/CaveTiles16.tscn")

static func create_room(opts) -> WoodsRoom:
	Debug.pr("Creating room", opts)

	var room_base_dim = Util.get_(opts, "room_base_dim", 256)
	var type = Util.get_(opts, "type", t.SQUARE)

	var room = WoodsRoom.new()
	room.position = Util.get_(opts, "position", Vector2.ZERO)

	# position should apply to room, not the rect
	var rec = ColorRect.new()
	rec.size = Util.get_(opts, "size", Vector2.ONE * room_base_dim)
	rec.color = Util.get_(opts, "color", Color.PERU)

	room.rect = rec

	var def = room_for_type(type)
	room.room_def = def

	room.tilemap = tmap_scene.instantiate()

	# TODO calculate tilemap scaling properly
	# var tile_size = room.tilemap
	# var tile_dims = len(def.shape)
	room.tilemap.scale = Vector2.ONE * 2

	var tile_cells = []
	for y in len(def.shape):
		var row = def.shape[y]
		for x in len(row):
			var coord = Vector2(x, y)
			var def_cell = def.shape[y][x]
			if def_cell != null and "Tile" in def_cell:
				tile_cells.append(coord)

	room.tilemap.set_cells_terrain_connect(0, tile_cells, 0, 0)
	room.tilemap.force_update()

	room.add_child(rec)
	room.add_child(room.tilemap)

	return room
