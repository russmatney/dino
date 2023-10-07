@tool
extends Node2D
class_name WoodsRoom

## vars, data ##################################################################

enum t {START, END, SQUARE, LONG, CLIMB, FALL}

var rect
var type
var room_def
var tilemap

## room parse ##################################################################

static func parse_room_defs(opts={}):
	if "parsed_room_defs" in opts:
		return opts.parsed_room_defs

	Debug.warn("parsing room defs")

	var path = Util.get_(opts, "room_defs_path", "res://src/woods/world/rooms.txt")
	var file = FileAccess.open(path, FileAccess.READ)
	var contents = file.get_as_text()

	return RoomParser.parse(contents)

static func room_for_type(typ, opts={}):
	var rooms_by_type = {}
	var room_defs = parse_room_defs(opts)
	for room in room_defs.rooms:
		var rms = Util.get_(rooms_by_type, room.room_type, [])
		rms.append(room)
		rooms_by_type[room.room_type] = rms

	var type_s
	match typ:
		t.START: type_s = "START"
		t.END: type_s = "END"
		t.SQUARE: type_s = "SQUARE"
		t.CLIMB: type_s = "CLIMB"
		t.FALL: type_s = "FALL"
		t.LONG: type_s = "LONG"

	return Util.rand_of(rooms_by_type[type_s])

## room_opts ##################################################################

static func next_room_opts(last_room, opts=null):
	if opts == null:
		opts = {}

	var typ = opts.get("type")
	if typ == null:
		typ = Util.rand_of([t.SQUARE, t.LONG, t.CLIMB, t.FALL])

	var room_base_dim = opts.get("room_base_dim", 256)

	var size
	match typ:
		t.SQUARE, t.START, t.END: size = Vector2.ONE * room_base_dim
		t.CLIMB, t.FALL: size = Vector2.ONE * room_base_dim * Vector2(1, 2)
		t.LONG: size = Vector2.ONE * room_base_dim * Vector2(2, 1)

	var pos
	match typ:
		t.START, t.END, t.SQUARE, t.FALL, t.LONG: pos = Vector2(
			last_room.position.x + last_room.rect.size.x, last_room.position.y
			)
		t.CLIMB: pos = Vector2(
			last_room.position.x + last_room.rect.size.x,
			last_room.position.y + last_room.rect.size.y - size.y,
			)
	if last_room != null and "type" in last_room:
		match [last_room.type, typ]:
			[t.CLIMB, t.CLIMB]: pos.y -= room_base_dim
			[_, t.CLIMB]: pass
			[t.FALL, _]: pos.y += room_base_dim

	var color
	match typ:
		t.SQUARE, t.START, t.END: color = Color.PERU
		t.LONG: color = Color.FUCHSIA
		t.FALL: color = Color.CRIMSON
		t.CLIMB: color = Color.AQUAMARINE

	opts.merge({
		position=pos, size=size, type=typ, color=color
		})
	return opts

# TODO assign tilemap into scene, maybe fetch based on room_def
static var fallback_tmap_scene = preload("res://addons/reptile/tilemaps/CaveTiles16.tscn")

static func calc_tilemap_scale_factor(room: WoodsRoom, room_base_dim: int):
	# Assumes we have square tiles
	var tile_size = room.tilemap.tile_set.tile_size
	# Assumes room def rows are all the same len
	var room_def_dims = Vector2(len(room.room_def.shape), len(room.room_def.shape[0]))
	# get shortest dimension
	var base_dim = room_def_dims.x if room_def_dims.x < room_def_dims.y else room_def_dims.y
	var base_tile_size = base_dim * tile_size.x
	return room_base_dim / base_tile_size

static func calc_coord_factor(room: WoodsRoom, room_base_dim: int):
	# Assumes room def rows are all the same len
	var room_def_dims = Vector2(len(room.room_def.shape), len(room.room_def.shape[0]))
	# get shortest dimension
	var base_dim = room_def_dims.x if room_def_dims.x < room_def_dims.y else room_def_dims.y
	return room_base_dim / base_dim

static var player_spawn_point_scene = preload("res://addons/core/PlayerSpawnPoint.tscn")
# TODO maybe want a first class Spawn addon for spawn points + restarts
static var spawn_point_scene = preload("res://src/Dino/SpawnPoint.tscn")
static var leaf_scene = preload("res://src/woods/entities/Leaf.tscn")
static func create_room(opts={}, last_room=null) -> WoodsRoom:
	if last_room != null:
		opts = next_room_opts(last_room, opts)
	var room_base_dim = Util.get_(opts, "room_base_dim", 256)
	var typ = Util.get_(opts, "type", t.SQUARE)

	var room = WoodsRoom.new()
	room.position = Util.get_(opts, "position", Vector2.ZERO)
	room.type = typ

	# position should apply to room, not the rect
	var rec = ColorRect.new()
	rec.name = "ColorRect"
	rec.size = Util.get_(opts, "size", Vector2.ONE * room_base_dim)
	rec.color = Util.get_(opts, "color", Color.PERU)
	rec.visible = opts.get("show_color_rect", false)

	room.rect = rec

	var def = room_for_type(typ, opts)
	room.room_def = def

	var tmap_scene = Util.get_(opts, "tilemap_scene", fallback_tmap_scene)
	room.tilemap = tmap_scene.instantiate()
	var tilemap_scale_factor = calc_tilemap_scale_factor(room, room_base_dim)
	room.tilemap.scale = Vector2.ONE * tilemap_scale_factor

	var tile_cells = []
	var player_cells = []
	var leaf_cells = []
	var filler_tile_count = opts.get("filler_tile_count", 50)
	var filler_above = opts.get("filler_above", false)
	for y in len(def.shape):
		var first_row = y == 0
		var last_row = y == len(def.shape) - 1

		var row = def.shape[y]
		for x in len(row):
			var coord = Vector2(x, y)
			var def_cell = def.shape[y][x]
			if def_cell != null and "Tile" in def_cell:
				tile_cells.append(coord)
				if filler_above and first_row:
					for i in filler_tile_count:
						tile_cells.append(Vector2(x, y - i))
				if last_row:
					for i in filler_tile_count:
						tile_cells.append(Vector2(x, y + i))
			if def_cell != null and "Player" in def_cell:
				player_cells.append(coord)
			if def_cell != null and "Leaf" in def_cell:
				leaf_cells.append(coord)

	if room.type == t.START:
		for i in filler_tile_count:
			for j in filler_tile_count:
				if filler_above:
					tile_cells.append(Vector2(-i, -j))
				tile_cells.append(Vector2(-i, j))
	if room.type == t.END:
		var w = len(def.shape[0])
		for i in filler_tile_count:
			for j in filler_tile_count:
				if filler_above:
					tile_cells.append(Vector2(i+w, -j))
				tile_cells.append(Vector2(i+w, j))

	room.tilemap.set_cells_terrain_connect(0, tile_cells, 0, 0)
	room.tilemap.force_update()

	var coord_factor = calc_coord_factor(room, room_base_dim)
	for p in player_cells:
		var spawn_point = player_spawn_point_scene.instantiate()
		spawn_point.position = p * coord_factor
		room.add_child(spawn_point)

	for l in leaf_cells:
		var spawn_point = spawn_point_scene.instantiate()
		spawn_point.position = l * coord_factor
		spawn_point.spawn_f = func():
			return leaf_scene.instantiate()
		room.add_child(spawn_point)

	room.add_child(rec)
	room.add_child(room.tilemap)

	return room
