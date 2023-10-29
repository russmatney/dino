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

static func add_entity(crd, room, ent_opts, opts):
	var ent = ent_opts.scene.instantiate()
	ent.position = crd_to_position(crd, opts) + Vector2.DOWN * opts.tile_size
	if ent_opts.get("setup"):
		ent_opts.setup.call(ent)
	room.add_child(ent)
	room.entities.append(ent)
	return ent

static func add_entities(room, opts):
	var crds = room.def.coords()
	for label in opts.label_to_entity:
		crds.filter(func(c): return label in c.cell).map(func(crd):
			add_entity(crd, room, opts.label_to_entity.get(label), opts))

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

# returns the number of tiles from the top to the first null above a Tile
# (the first "floor" from the top)
# if there are no tiles to stand on, or no tiles with an empty tile above them, returns 0.
static func count_to_floor_tile(col: Array):
	var v_count = len(col)
	var _col = col.duplicate()

	_col.reverse()
	var from_bottom_count = 0
	var seen_tile = false
	for c in _col:
		if c is Array and "Tile" in c:
			from_bottom_count += 1
			seen_tile = true
		elif c == null and not seen_tile:
			from_bottom_count += 1

		if seen_tile and from_bottom_count > 0 and c == null:
			break

	return v_count - from_bottom_count

static func next_room_position(opts: Dictionary, room, last_room):
	var x = last_room.position.x + BrickRoom.width(last_room, opts)

	var lr_offset = count_to_floor_tile(last_column(last_room))
	var tr_offset = count_to_floor_tile(first_column(room))

	var y_offset = (lr_offset - tr_offset) * opts.tile_size

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

func to_pretty(a, b, c):
	return Debug.to_pretty(["BrickRoom", {def=Debug.to_pretty(def, a, b, c), rect=rect, entities=entities}], a, b, c)

## gen #############################################################

func gen(opts: Dictionary):
	Util.ensure_default(opts, "tile_size", 16)
	Util.ensure_default(opts, "flags", [])
	Util.ensure_default(opts, "skip_flags", [])
	Util.ensure_default(opts, "tilemap_scene", load("res://addons/reptile/tilemaps/MetalTiles8.tscn"))
	Util.ensure_default(opts, "label_to_entity", {})
	var last_room = opts.get("last_room")

	def = gen_room_def(opts)
	if def.name != null and def.name != "":
		name = def.name

	# TODO support configurable next-room-position patterns (door alignment, etc)
	position = Vector2.ZERO if last_room == null else BrickRoom.next_room_position(opts, self, last_room)

	# will we need to overwrite `gen` completely? maybe need to decouple this class?
	BrickRoom.add_rect(self, opts)
	BrickRoom.add_tilemap(self, opts)
	BrickRoom.add_entities(self, opts)

## _ready ####################################################################

func _ready():
	# TODO find and set rect, tilemap, entities.... def?
	pass
