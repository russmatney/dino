@tool
class_name BrickRoom
extends Node2D

class BrickRoomOpts:
	extends Object

	var parsed_room_defs: GridDefs
	var defs_path: String
	var contents: String

	var tile_size: int
	var side: Vector2
	var flags: Array
	var skip_flags: Array
	var label_to_tilemap: Dictionary
	var label_to_entity: Dictionary
	var color: Color
	var show_color_rect: bool

	# does this need to be optional?
	var last_room: BrickRoom

	# the input with defaults applied
	# useful for a quick data() func, and passing this down to other funcs
	var _opts: Dictionary

	func _init(opts):
		U.ensure_default(opts, "side", Vector2.RIGHT)
		U.ensure_default(opts, "tile_size", 16)
		U.ensure_default(opts, "flags", [])
		U.ensure_default(opts, "skip_flags", [])
		U.ensure_default(opts, "label_to_tilemap", {"Tile": {scene=load("res://src/tilemaps/metal/MetalTiles8.tscn")}})
		U.ensure_default(opts, "label_to_entity", {})
		U.ensure_default(opts, "color", Color.PERU)
		U.ensure_default(opts, "show_color_rect", false)
		U.ensure_default(opts, "defs_path", "")
		U.ensure_default(opts, "contents", "")

		_opts = opts

		parsed_room_defs = opts.get("parsed_room_defs")
		defs_path = opts.get("defs_path", "")
		contents = opts.get("contents", "")

		tile_size = opts.tile_size
		side = opts.side
		flags = opts.flags
		skip_flags = opts.skip_flags
		label_to_tilemap = opts.label_to_tilemap
		label_to_entity = opts.label_to_entity
		color = opts.color
		show_color_rect = opts.show_color_rect

		last_room = opts.get("last_room")

	func data():
		return _opts

##########################################################################
## static ##################################################################

static func width(room: BrickRoom, opts: Variant):
	return len(room.def.shape[0]) * opts.tile_size

static func height(room: BrickRoom, opts: Variant):
	return len(room.def.shape) * opts.tile_size

static func size(room: BrickRoom, opts: Variant):
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

static func add_tilemap(room: BrickRoom, opts: BrickRoomOpts, label: String, tmap_opts: Dictionary):
	var scene = tmap_opts.get("scene", load("res://src/tilemaps/metal/MetalTiles8.tscn"))
	var tilemap = scene.instantiate()

	var tilemap_tile_size = tilemap.tile_set.tile_size
	var tilemap_scale_factor = opts.tile_size*Vector2.ONE/(tilemap_tile_size as Vector2)
	tilemap.scale = Vector2.ONE * tilemap_scale_factor

	var crds = room.def.coords()
	var tile_coords = crds.filter(func(c): return label in c.cell).map(func(c): return c.coord)
	if len(tile_coords) == 0:
		# no tiles for label in this room
		return

	tilemap.set_cells_terrain_connect(tile_coords, 0, 0)
	tilemap.update_internals()

	room.tilemaps[label] = tilemap
	room.add_child(tilemap)

static func add_tilemaps(room: BrickRoom, opts: BrickRoomOpts):
	for label in opts.label_to_tilemap:
		add_tilemap(room, opts, label, opts.label_to_tilemap.get(label))

## entities ##################################################################

static func add_entity(crd, room: BrickRoom, ent, opts: BrickRoomOpts):
	var node
	if ent is PandoraEntity:
		node = ent.get_scene().instantiate()
	elif ent is Dictionary:
		if "scene" in ent:
			node = ent.scene.instantiate()
	if not node:
		Log.warn("Could not create node for entity", ent)
	node.position = crd_to_position(crd, opts)
	room.add_child(node)
	room.entities.append(node)
	return ent

static func add_entities(room, opts):
	for crd in room.def.coords():
		for label in crd.cell:
			if label in ["Tile", "Empty"]:
				continue
			var ent = DinoEntity.entity_for_label(label)
			if not ent:
				ent = DinoEnemy.enemy_for_label(label)
			if not ent:
				ent = opts.label_to_entity.get(label)
			if not ent:
				Log.warn("No dino entity/enemy for label, skipping", label)
				continue
			add_entity(crd, room, ent, opts)

## color rect ##################################################################

static func add_color_rect(room: BrickRoom, opts: BrickRoomOpts):
	var rec = ColorRect.new()
	rec.name = "ColorRect"
	rec.size = BrickRoom.size(room, opts)
	rec.color = opts.color
	rec.visible = opts.show_color_rect

	room.rect = rec
	room.add_child(rec)

## area2d ######################################################################

static func add_roombox(room: BrickRoom, _opts: BrickRoomOpts):
	var coll = Reptile.rect_to_collision_shape(Rect2(room.rect.position, room.rect.size))

	var box = Area2D.new()
	box.add_child(coll)
	coll.set_owner(box)
	box.name = "RoomBox"
	box.set_visible(false)
	box.add_to_group("roombox", true)

	box.set_collision_layer_value(1, false)
	box.set_collision_mask_value(1, false)
	box.set_collision_mask_value(2, true) # 2 for player

	room.add_child(box)

## room gen ##################################################################

static func gen_room_def(opts: BrickRoomOpts, d_opts: Dictionary={}):
	if opts == null:
		opts = BrickRoomOpts.new(d_opts)
	var room_defs = GridParser.parse(opts.data())
	if not room_defs:
		Log.warn("No room_defs parsed from opts.data()!", opts.data())
		return
	var filtered_rooms = room_defs.filter(opts.data())
	if filtered_rooms != null:
		return U.rand_of(filtered_rooms)
	Log.error("Failed to generated room_def with opts", opts)

## next room position ##################################################################

# returns the number of tiles from the top to the first null above a Tile
# (the first "floor" from the top)
# if there are no tiles to stand on, or no tiles with an empty tile above them, returns 0.
static func count_to_floor_tile(col: Array):
	var v_count = len(col)
	var _col = col.duplicate(true)

	_col.reverse()
	var from_bottom_count = 0
	var seen_tile = false
	for c in _col:
		var c_has_tile = c is Array and "Tile" in c
		if c_has_tile:
			from_bottom_count += 1
			seen_tile = true
		elif not seen_tile:
			from_bottom_count += 1

		if seen_tile and from_bottom_count > 0 and not c_has_tile:
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

	Log.warn("Unsupported 'side' option passed", opts.side)


## create room ##################################################################

static func create_room(opts):
	var room = BrickRoom.new()
	var brick_opts = BrickRoomOpts.new(opts)

	room.def = gen_room_def(brick_opts)
	if not room.def:
		Log.warn("No def gend for brick_opts", brick_opts)
		return
	if room.def.name != null and room.def.name != "":
		room.name = room.def.name

	room.position = BrickRoom.next_room_position(room, brick_opts)

	BrickRoom.add_color_rect(room, brick_opts)
	BrickRoom.add_roombox(room, brick_opts)
	BrickRoom.add_tilemaps(room, brick_opts)
	BrickRoom.add_entities(room, brick_opts)
	return room

static func create_rooms(room_opts):
	var last_room = null
	var rooms = []
	for i in len(room_opts):
		var opts = room_opts[i]
		if last_room != null:
			opts.last_room = last_room
		last_room = BrickRoom.create_room(room_opts[i])
		if not last_room:
			continue
		rooms.append(last_room)
	return rooms

##########################################################################
## instance ##################################################################

## vars

var def: GridDef
var rect: ColorRect
var tilemaps: Dictionary = {}
var entities: Array

func data():
	return {name=name, def=def, entities=entities, tilemaps=tilemaps}
