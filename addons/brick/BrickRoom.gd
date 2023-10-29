@tool
class_name BrickRoom
extends Node2D

# TODO consider a stronger type for the opts Dictionary in here

##########################################################################
## static ##################################################################

static func width(room: BrickRoom, opts: Dictionary):
	return len(room.def.shape[0]) * opts.tile_size

static func height(room: BrickRoom, opts: Dictionary):
	return len(room.def.shape) * opts.tile_size

static func size(room: BrickRoom, opts: Dictionary):
	return Vector2(width(room, opts), height(room, opts))

static func last_column(room: BrickRoom):
	return room.def.column(len(room.def.shape[0]) - 1)

static func first_column(room: BrickRoom):
	return room.def.column(0)

static func crd_to_position(crd, opts: Dictionary):
	return crd.coord * opts.tile_size

## tilemap ##################################################################

static func add_tilemap(room, opts):
	var tmap_scene = Util.get_(opts, "tilemap_scene")
	if tmap_scene == null:
		Debug.error("No tilemap scene passed to add_tilemap", opts)
		return

	room.tilemap = tmap_scene.instantiate()

	var tilemap_tile_size = room.tilemap.tile_set.tile_size
	var tilemap_scale_factor = opts.tile_size*Vector2.ONE/(tilemap_tile_size as Vector2)
	room.tilemap.scale = Vector2.ONE * tilemap_scale_factor

	var crds = room.def.coords()
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
	return ent

static func add_entities(room, opts):
	var crds = room.def.coords()
	for label in opts.label_to_entity_scene:
		crds.filter(func(c): return label in c.cell).map(func(crd):
			add_entity(crd, room, opts.label_to_entity_scene.get(label), opts))

## color rect ##################################################################

static func add_rect(room: BrickRoom, opts: Dictionary):
	var rec = ColorRect.new()
	rec.name = "ColorRect"
	rec.size = Util.get_(opts, "size", BrickRoom.size(room, opts))
	rec.color = Util.get_(opts, "color", Color.PERU)
	# rec.visible = opts.get("show_color_rect", false)

	room.rect = rec
	room.add_child(rec)

## room gen ##################################################################

static func gen_room_def(opts={}):
	var room_defs = RoomParser.parse(opts)
	var filtered_rooms = room_defs.filter(opts)
	if filtered_rooms != null:
		return Util.rand_of(filtered_rooms)
	Debug.error("Failed to generated room_def with opts", opts)

## next room position ##################################################################

static func tile_count_from_floor(col: Array):
	col.reverse()
	var tile_count = 0
	for c in col:
		if c is Array and "Tile" in c:
			tile_count += 1
	return tile_count

static func next_room_position(opts: Dictionary, room, last_room):
	var x = last_room.position.x + BrickRoom.width(last_room, opts)

	var last_room_final_col = last_column(last_room)
	var last_room_offset_tile_count = len(last_room_final_col) - tile_count_from_floor(last_room_final_col)

	var this_room_first_col = first_column(room)
	var this_room_offset_tile_count = len(this_room_first_col) - tile_count_from_floor(this_room_first_col)

	var y_offset = (last_room_offset_tile_count - this_room_offset_tile_count) * opts.tile_size

	var y = last_room.position.y + y_offset
	return Vector2(x, y)

## create room ##################################################################

static func create_room(opts):
	var room = BrickRoom.new()
	room.gen(opts)
	return room

##########################################################################
## instance ##################################################################

## vars

var def: RoomDef
var rect: ColorRect
var tilemap: TileMap
var entities: Array

## gen #############################################################

func gen(opts: Dictionary):
	Util.ensure_default(opts, "tile_size", 16)
	Util.ensure_default(opts, "flags", [])
	Util.ensure_default(opts, "skip_flags", [])
	var last_room = opts.get("last_room")

	def = gen_room_def(opts)
	name = def.name # may be null

	# TODO support configurable next-room-position patterns (door alignment, etc)
	position = Vector2.ZERO if last_room == null else BrickRoom.next_room_position(opts, self, last_room)

	# will we need to overwrite `gen` completely? maybe need to decouple this class?
	BrickRoom.add_rect(self, opts)
	BrickRoom.add_tilemap(self, opts)
	BrickRoom.add_entities(self, opts)
