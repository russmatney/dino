@tool
extends Node2D
class_name BrickLevelGen

################################################################################
## static ######################################################################

static func generate_level(opts: Dictionary) -> Dictionary:
	Util.ensure_default(opts, "seed", 1)
	Util.ensure_default(opts, "tile_size", 16)
	Debug.pr("Generating level with seed:", [opts.seed])

	# parse once
	var parsed_room_defs = RoomParser.parse({
		room_defs_path=opts.get("room_defs_path"),
		contents=opts.get("contents"),
		})

	# set seed
	seed(opts.seed)

	# get room opts
	var get_room_opts = opts.get("get_room_opts", BrickLevelGen.default_room_opts)
	var room_opts = get_room_opts.call(opts)
	for room_opt in room_opts:
		room_opt.merge(opts) # merge tile_size and other passed opts
		room_opt.merge({parsed_room_defs=parsed_room_defs,})
	if room_opts == null:
		Debug.warn("No room_opts returned from get_room_opts, nothing to generate")
		return {}

	# create the rooms
	var rooms = BrickRoom.create_rooms(room_opts)

	var room_idx = 0
	for r in rooms:
		r.name = "Room_%s" % room_idx
		room_idx += 1

	# combine tilemaps
	var tilemaps = BrickLevelGen.combine_tilemaps(rooms, room_opts)

	# collect entities
	var entities = []
	for room in rooms:
		for ent in room.entities:
			entities.append(ent)

	# build update dict
	var data = {
		seed=opts.seed,
		rooms=rooms,
		entities=entities,
		tilemaps=tilemaps,
		}

	return data

static func default_room_opts(opts):
	var room_opts = []
	for i in range(opts.room_count):
		room_opts.append({})
	return room_opts

## combine tilemaps ######################################################################

static func combine_tilemaps(rooms, room_opts):
	var label_to_tilemap = room_opts[0].label_to_tilemap

	var tmaps = []
	for label in label_to_tilemap:
		tmaps.append(BrickLevelGen.combine_tilemap(rooms, label, label_to_tilemap[label]))

	return tmaps

# converts a coord in a room's tilemap to a coord in the 'combined' passed tilemap
static func room_tilemap_coord_to_new_tilemap_coord(room, room_tilemap, coord, tilemap):
	var new_pos = room_tilemap.map_to_local(coord) + (room.position / room_tilemap.scale) + room_tilemap.position
	return tilemap.local_to_map(new_pos)

static func combine_tilemap(rooms, label, opts):
	var add_borders = opts.get("add_borders")
	var scene = opts.get("scene", load("res://addons/reptile/tilemaps/MetalTiles8.tscn"))
	var tilemap = scene.instantiate()

	var room_tilemap = func(room):
		return room.tilemaps.get(label)

	var is_scale_set = false

	var room_rects = []
	for r in rooms:
		var tmap = room_tilemap.call(r)
		if tmap == null:
			continue

		# set tilemap scale
		if not is_scale_set:
			tilemap.scale = tmap.scale
			is_scale_set = true

		# collect rects
		if add_borders:
			var rect = tmap.get_used_rect()
			rect.position = tmap.local_to_map(r.position / tmap.scale + tmap.position)
			room_rects.append(rect)

	var new_cell_coords = []
	var border_cells = []

	for r in rooms:
		var tmap = room_tilemap.call(r)
		if tmap == null:
			continue

		new_cell_coords.append_array(tmap.get_used_cells(0).map(func(coord):
			return BrickLevelGen.room_tilemap_coord_to_new_tilemap_coord(r, tmap, coord, tilemap)))

		if add_borders:
			# add border coords that don't overlap room_rects
			# NOTE assumes rooms are rectangles until this function gets more nuanced
			var border_coords = Reptile.all_tilemap_border_coords(tmap)
			for c in border_coords:
				var coord = BrickLevelGen.room_tilemap_coord_to_new_tilemap_coord(r, tmap, c, tilemap)
				var overlaps = false
				for rect in room_rects:
					if rect.has_point(coord):
						overlaps = true
						break
				if not overlaps:
					border_cells.append(coord)

		# this clean up might not be necessary
		r.remove_child(tmap)
		tmap.queue_free()

	if add_borders:
		new_cell_coords.append_array(border_cells)

	tilemap.set_cells_terrain_connect(0, new_cell_coords, 0, 0)
	tilemap.force_update()

	return tilemap

################################################################################
## instance ######################################################################

## signals ######################################################################

signal new_data_generated(data: Dictionary)

## vars/triggers ######################################################################

@export var run_gen: bool:
	set(v):
		if v and Engine.is_editor_hint():
			generate()

@export var _seed: int
@export var gen_with_random_seed: bool:
	set(v):
		if v and Engine.is_editor_hint():
			_seed = randi()
			generate()

@export var tile_size = 16
@export var room_count = 5
@export_file var room_defs_path

## generate ######################################################################

func generate():
	var opts = {
		seed=_seed,
		tile_size=tile_size,
		room_count=room_count,
		room_defs_path=room_defs_path,
		}
	if self.has_method("get_room_opts"):
		opts["get_room_opts"] = self.get_room_opts

	var data = BrickLevelGen.generate_level(opts)

	new_data_generated.emit(data)
