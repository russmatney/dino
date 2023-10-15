@tool
extends Node2D
class_name PluggsRoom

var def: Dictionary # a room def (TODO consider proper type)
var rect: ColorRect
var tilemap: TileMap

##########################################################################
## static ##################################################################

## helpers ##################################################################

static func width(room: PluggsRoom, opts: Dictionary):
	return len(room.def.shape[0]) * opts.tile_size

static func size(room: PluggsRoom, opts: Dictionary):
	var y = len(room.def.shape) * opts.tile_size
	var x = len(room.def.shape[0]) * opts.tile_size
	return Vector2(x, y)

static func coords(room: PluggsRoom):
	var crds = []
	for y in len(room.def.shape):
		var row = room.def.shape[y]
		for x in len(row):
			var coord = Vector2(x, y)
			var cell = room.def.shape[y][x]
			if cell != null:
				crds.append({coord=coord, cell=cell})
	return crds

## tilemap ##################################################################

static var fallback_tmap_scene = preload("res://addons/reptile/tilemaps/MetalTiles8.tscn")

static func add_tilemap(room, opts, crds):
	var tmap_scene = Util.get_(opts, "tilemap_scene", fallback_tmap_scene)
	room.tilemap = tmap_scene.instantiate()

	# TODO tilemap scaling?
	var tilemap_tile_size = room.tilemap.tile_set.tile_size
	var tilemap_scale_factor = opts.tile_size*Vector2.ONE/(tilemap_tile_size as Vector2)
	room.tilemap.scale = Vector2.ONE * tilemap_scale_factor

	var tile_coords = crds.filter(func(c): return "Tile" in c.cell).map(func(c): return c.coord)

	room.tilemap.set_cells_terrain_connect(0, tile_coords, 0, 0)
	room.tilemap.force_update()
	room.add_child(room.tilemap)


## color rect ##################################################################

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
	# TODO not sure i buy this default - maybe room_unit_size is cleaner
	Util.ensure_default(opts, "tile_size", 16)

	var room = PluggsRoom.new()
	room.def = gen_room_def(opts)
	room.name = room.def.get("name", "PluggsRoom")
	room.position = Vector2.ZERO if last_room == null else PluggsRoom.next_room_position(opts, room, last_room)

	add_rect(room, opts)
	var crds = coords(room)
	add_tilemap(room, opts, crds)


	return room
