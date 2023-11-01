@tool
extends Node2D
class_name BrickLevelGen

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

@export var room_tile_size = 16
@export var room_count = 5
@export_file var room_defs_path
var parsed_room_defs

@export var tilemap_scene: PackedScene

########################################################################

var rooms = []
var entities = []
var tilemaps = []
var room_idx = 0

## ready ######################################################################

func _ready():
	Debug.pr([&"Brick"], "BrickLevelGen ready")
	Game.maybe_spawn_player()

## reset ######################################################################

func reset():
	# clear
	rooms = []
	entities = []
	tilemaps = []

	# reset
	room_idx = 0
	parsed_room_defs = RoomParser.parse({room_defs_path=room_defs_path})

## generate ######################################################################

func generate() -> Dictionary:
	reset()
	seed(_seed)
	Debug.pr("Generating level with seed:", [_seed])

	var room_opts = get_room_opts()
	for opt in room_opts:
		opt.merge({tile_size=room_tile_size, parsed_room_defs=parsed_room_defs,})
	if room_opts == null:
		Debug.warn("No room_opts returned from get_room_opts, nothing to generate")
		return {}
	rooms = BrickRoom.create_rooms(room_opts)

	for r in rooms:
		r.name = "Room_%s" % room_idx
		room_idx += 1

	tilemaps = combine_tilemaps(rooms, room_opts)

	# collect entities
	entities = []
	for room in rooms:
		for ent in room.entities:
			entities.append(ent)

	# emit updates
	var data = {
		seed=_seed,
		rooms=rooms,
		entities=entities,
		tilemaps=tilemaps,
		}

	new_data_generated.emit(data)

	return data

# overwrite in subclass
func get_room_opts():
	Debug.err("Not impled!")
	# provide a sane, opts-driven default
	# (so you don't _need_ to write a sub-class)

## promote tilemaps ######################################################################

func combine_tilemaps(rooms, room_opts):
	var label_to_tilemap = room_opts[0].label_to_tilemap

	var tmaps = []
	for label in label_to_tilemap:
		tmaps.append(combine_tilemap(rooms, label, label_to_tilemap[label]))

	return tmaps

# converts a coord in a room's tilemap to a coord in the 'combined' passed tilemap
func room_tilemap_coord_to_new_tilemap_coord(room, room_tilemap, coord, tilemap):
	var new_pos = room_tilemap.map_to_local(coord) + (room.position / room_tilemap.scale) + room_tilemap.position
	return tilemap.local_to_map(new_pos)

func combine_tilemap(rooms, label, opts):
	var add_borders = opts.get("add_borders")

	assert(opts.scene, "No scene passed in tilemap opts")
	var tilemap = opts.scene.instantiate()

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
			return room_tilemap_coord_to_new_tilemap_coord(r, tmap, coord, tilemap)))

		if add_borders:
			# add border coords that don't overlap room_rects
			# NOTE assumes rooms are rectangles until this function gets more nuanced
			var border_coords = Reptile.all_tilemap_border_coords(tmap)
			for c in border_coords:
				var coord = room_tilemap_coord_to_new_tilemap_coord(r, tmap, c, tilemap)
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
