@tool
extends Node2D
class_name PluggsRoom

##########################################################################
## static ##################################################################

## helpers ##################################################################

static func width(room: PluggsRoom, opts: Dictionary):
	return len(room.def.shape[0]) * opts.tile_size

# move to RoomDef
static func column(room: PluggsRoom, idx: int):
	var col = []
	for row in room.def.shape:
		if idx >= len(row):
			Debug.error("idx outside of row width, cannot build column")
			return []
		col.append(row[idx])
	return col

static func last_column(room: PluggsRoom):
	return column(room, len(room.def.shape[0]) - 1)

static func first_column(room: PluggsRoom):
	return column(room, 0)

static func size(room: PluggsRoom, opts: Dictionary):
	var y = len(room.def.shape) * opts.tile_size
	var x = len(room.def.shape[0]) * opts.tile_size
	return Vector2(x, y)

static func crd_to_position(crd, opts: Dictionary):
	return crd.coord * opts.tile_size

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

	var tilemap_tile_size = room.tilemap.tile_set.tile_size
	var tilemap_scale_factor = opts.tile_size*Vector2.ONE/(tilemap_tile_size as Vector2)
	room.tilemap.scale = Vector2.ONE * tilemap_scale_factor

	var tile_coords = crds.filter(func(c): return "Tile" in c.cell).map(func(c): return c.coord)

	room.tilemap.set_cells_terrain_connect(0, tile_coords, 0, 0)
	room.tilemap.force_update()
	room.add_child(room.tilemap)

## entities ##################################################################

static func add_entity(crd, room, scene, opts):
	var ent = scene.instantiate()
	ent.position = crd_to_position(crd, opts) + Vector2.DOWN * opts.tile_size
	room.add_child(ent)
	room.entities.append(ent)

static var player_spawn_point = preload("res://addons/core/PlayerSpawnPoint.tscn")
static var fb_machine_scene = preload("res://src/pluggs/entities/ArcadeMachine.tscn")
static var fb_light_scene = preload("res://src/pluggs/entities/Light.tscn")

static func add_entities(room, opts, crds):
	var light_scene = Util.get_(opts, "light_scene", fb_light_scene)
	var machine_scene = Util.get_(opts, "machine_scene", fb_machine_scene)

	crds.filter(func(c): return "Light" in c.cell).map(func(crd): add_entity(crd, room, light_scene, opts))
	crds.filter(func(c): return "Machine" in c.cell).map(func(crd): add_entity(crd, room, machine_scene, opts))
	crds.filter(func(c): return "Player" in c.cell).map(func(crd): add_entity(crd, room, player_spawn_point, opts))

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

	if len(opts.flags) > 0:
		room_defs = room_defs.filter(func(r):
			for flag in opts.flags:
				if flag in r and r[flag]: #move to room.meta when RoomDef type exists
					return true)

	if len(opts.skip_flags) > 0:
		room_defs = room_defs.filter(func(r):
			for flag in opts.skip_flags:
				if flag in r and r[flag]: #move to room.meta when RoomDef type exists
					return false
			return true)

	if len(room_defs) == 0:
		Debug.err("Could not find room_def matching `filter_rooms` and `flags`", opts.flags)
		return

	return Util.rand_of(room_defs)

## next room position ##################################################################

static func tile_count_from_floor(col: Array):
	col.reverse()
	var tile_count = 0
	for c in col:
		if c is Array and "Tile" in c:
			tile_count += 1
	return tile_count

static func next_room_position(opts: Dictionary, room, last_room):
	var x = last_room.position.x + PluggsRoom.width(last_room, opts)

	var last_room_final_col = last_column(last_room)
	var last_room_offset_tile_count = len(last_room_final_col) - tile_count_from_floor(last_room_final_col)

	var this_room_first_col = first_column(room)
	var this_room_offset_tile_count = len(this_room_first_col) - tile_count_from_floor(this_room_first_col)

	var y_offset = (last_room_offset_tile_count - this_room_offset_tile_count) * opts.tile_size

	var y = last_room.position.y + y_offset
	return Vector2(x, y)

## create room ##################################################################

static func create_room(opts, last_room=null):
	Util.ensure_default(opts, "tile_size", 16)
	Util.ensure_default(opts, "flags", [])
	Util.ensure_default(opts, "skip_flags", [])

	var room = PluggsRoom.new()
	room.def = gen_room_def(opts)
	room.name = room.def.get("name", "PluggsRoom")
	room.position = Vector2.ZERO if last_room == null else PluggsRoom.next_room_position(opts, room, last_room)

	add_rect(room, opts)
	var crds = coords(room)
	add_tilemap(room, opts, crds)
	add_entities(room, opts, crds)

	return room

##########################################################################
## instance ##################################################################

## vars

var def: Dictionary
# var def: RoomDef
var rect: ColorRect
var tilemap: TileMap
var entities: Array

## ready #############################################################

func _ready():
	pass
