@tool
class_name BrickRoom
extends Node2D

# TODO consider a stronger type for the opts Dictionary in here

class BrickRoomOpts:
	extends Object

	var parsed_room_defs: RoomDefs
	var room_defs_path: String
	var contents: String

	var tile_size: int
	var side: Vector2
	var flags: Array
	var skip_flags: Array
	var tilemap_scene: PackedScene
	var label_to_entity: Dictionary
	var color: Color
	var show_color_rect: bool

	# does this need to be optional?
	var last_room: BrickRoom

	# the input with defaults applied
	# useful for a quick data() func, and passing this down to other funcs
	var _opts: Dictionary

	func _init(opts):
		Util.ensure_default(opts, "side", Vector2.RIGHT)
		Util.ensure_default(opts, "tile_size", 16)
		Util.ensure_default(opts, "flags", [])
		Util.ensure_default(opts, "skip_flags", [])
		Util.ensure_default(opts, "tilemap_scene", load("res://addons/reptile/tilemaps/MetalTiles8.tscn"))
		Util.ensure_default(opts, "label_to_entity", {})
		Util.ensure_default(opts, "color", Color.PERU)
		Util.ensure_default(opts, "show_color_rect", true)

		_opts = opts

		parsed_room_defs = opts.get("parsed_room_defs")
		room_defs_path = opts.get("room_defs_path", "")
		contents = opts.get("contents", "")

		tile_size = opts.tile_size
		side = opts.side
		flags = opts.flags
		skip_flags = opts.skip_flags
		tilemap_scene = opts.tilemap_scene
		label_to_entity = opts.label_to_entity
		color = opts.color
		show_color_rect = opts.show_color_rect

		last_room = opts.get("last_room")

	func data():
		return _opts

	func to_pretty(a, b, c):
		return Debug.to_pretty(data(), a, b, c)

##########################################################################
## static ##################################################################

static func width(room: BrickRoom, opts: BrickRoomOpts):
	return len(room.def.shape[0]) * opts.tile_size

static func height(room: BrickRoom, opts: BrickRoomOpts):
	return len(room.def.shape) * opts.tile_size

static func size(room: BrickRoom, opts: BrickRoomOpts):
	return Vector2(width(room, opts), height(room, opts))

static func last_column(room: BrickRoom):
	return room.def.column(len(room.def.shape[0]) - 1)

static func first_column(room: BrickRoom):
	return room.def.column(0)

static func last_row(room: BrickRoom):
	return room.def.row(len(room.def.shape) - 1)

static func first_row(room: BrickRoom):
	return room.def.row(0)

static func crd_to_position(crd: Dictionary, opts: BrickRoomOpts):
	return crd.coord * opts.tile_size

## tilemap ##################################################################

static func add_tilemap(room: BrickRoom, opts: BrickRoomOpts):
	room.tilemap = opts.tilemap_scene.instantiate()

	var tilemap_tile_size = room.tilemap.tile_set.tile_size
	var tilemap_scale_factor = opts.tile_size*Vector2.ONE/(tilemap_tile_size as Vector2)
	room.tilemap.scale = Vector2.ONE * tilemap_scale_factor

	var crds = room.def.coords()
	var tile_coords = crds.filter(func(c): return "Tile" in c.cell).map(func(c): return c.coord)

	room.tilemap.set_cells_terrain_connect(0, tile_coords, 0, 0)
	room.tilemap.force_update()
	room.add_child(room.tilemap)

## entities ##################################################################

static func add_entity(crd, room: BrickRoom, ent_opts, opts: BrickRoomOpts):
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

static func add_rect(room: BrickRoom, opts: BrickRoomOpts):
	var rec = ColorRect.new()
	rec.name = "ColorRect"
	rec.size = BrickRoom.size(room, opts)
	rec.color = opts.color
	# rec.visible = opts.get("show_color_rect", false)

	room.rect = rec
	room.add_child(rec)

## room gen ##################################################################

static func gen_room_def(opts: BrickRoomOpts, d_opts: Dictionary={}):
	if opts == null:
		opts = BrickRoomOpts.new(d_opts)
	var room_defs = RoomParser.parse(opts.data())
	var filtered_rooms = room_defs.filter(opts.data())
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

static func next_room_pos_right(room: BrickRoom, opts: BrickRoomOpts):
	var last_room = opts.last_room

	var x = last_room.position.x + BrickRoom.width(last_room, opts)

	var lr_offset = count_to_floor_tile(last_column(last_room))
	var tr_offset = count_to_floor_tile(first_column(room))
	var y_offset = (lr_offset - tr_offset) * opts.tile_size

	var y = last_room.position.y + y_offset
	return Vector2(x, y)

static func next_room_pos_left(room: BrickRoom, opts: BrickRoomOpts):
	var last_room = opts.last_room

	var x = last_room.position.x - BrickRoom.width(room, opts)

	var lr_offset = count_to_floor_tile(first_column(last_room))
	var tr_offset = count_to_floor_tile(last_column(room))
	var y_offset = (lr_offset - tr_offset) * opts.tile_size

	var y = last_room.position.y + y_offset
	return Vector2(x, y)

static func next_room_pos_top(room: BrickRoom, opts: BrickRoomOpts):
	var last_room = opts.last_room

	var y = last_room.position.y - BrickRoom.height(room, opts)

	var lr_offset = count_to_floor_tile(first_row(last_room))
	var tr_offset = count_to_floor_tile(last_row(room))
	var x_offset = (lr_offset - tr_offset) * opts.tile_size

	var x = last_room.position.x + x_offset
	return Vector2(x, y)

static func next_room_pos_bottom(room: BrickRoom, opts: BrickRoomOpts):
	var last_room = opts.last_room

	var y = last_room.position.y + BrickRoom.height(last_room, opts)

	var lr_offset = count_to_floor_tile(last_row(last_room))
	var tr_offset = count_to_floor_tile(first_row(room))
	var x_offset = (lr_offset - tr_offset) * opts.tile_size

	var x = last_room.position.x + x_offset
	return Vector2(x, y)

static func next_room_position(room: BrickRoom, opts: BrickRoomOpts):
	if opts.get("last_room") == null:
		return Vector2.ZERO

	match opts.side:
		Vector2.RIGHT: return BrickRoom.next_room_pos_right(room, opts)
		Vector2.LEFT: return BrickRoom.next_room_pos_left(room, opts)
		Vector2.UP: return BrickRoom.next_room_pos_top(room, opts)
		Vector2.DOWN: return BrickRoom.next_room_pos_bottom(room, opts)

	Debug.warn("Unsupported 'side' option passed", opts.side)


## create room ##################################################################

static func create_room(opts):
	var room = BrickRoom.new()
	room.gen(opts)
	return room

static func create_rooms(room_opts):
	var last_room
	var rooms = []
	for i in len(room_opts):
		var opts = room_opts[i]
		if last_room != null:
			opts.last_room = last_room
		last_room = BrickRoom.create_room(room_opts[i])
		rooms.append(last_room)
	return rooms

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
	var brick_opts = BrickRoomOpts.new(opts)

	def = gen_room_def(brick_opts)
	if def.name != null and def.name != "":
		name = def.name

	position = BrickRoom.next_room_position(self, brick_opts)

	# will we need to overwrite `gen` completely? maybe need to decouple this class?
	BrickRoom.add_rect(self, brick_opts)
	BrickRoom.add_tilemap(self, brick_opts)
	BrickRoom.add_entities(self, brick_opts)

## _ready ####################################################################

func _ready():
	# TODO find and set rect, tilemap, entities.... def?
	pass
