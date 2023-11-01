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
@export_file var room_defs_path = "res://src/shirt/gen/room_defs.txt"
var parsed_room_defs

@export var tilemap_scene: PackedScene = preload("res://addons/reptile/tilemaps/CaveTiles16.tscn")

########################################################################

var rooms = []
var entities = []
var tilemaps = []

var room_idx = 0

## ready ######################################################################

func _ready():
	Debug.pr([&"Brick"], "BrickLevelGen ready")
	Game.maybe_spawn_player()

## generate ######################################################################

func reset():
	# clear
	rooms = []
	entities = []
	tilemaps = []

	# reset
	room_idx = 0
	parsed_room_defs = RoomParser.parse({room_defs_path=room_defs_path})

func generate():
	reset()

	seed(_seed)
	Debug.pr("Generating level with seed:", _seed)

	var room_opts = [
		{flags=["first"]},
		{skip_flags=["first"], side=Vector2.RIGHT},
		{skip_flags=["first"], side=Util.rand_of([Vector2.UP, Vector2.DOWN])},
		{skip_flags=["first"], side=Util.rand_of([Vector2.RIGHT, Vector2.LEFT])},
		]

	for opt in room_opts:
		opt.merge({
			tile_size=room_tile_size,
			parsed_room_defs=parsed_room_defs,
			tilemap_scene=tilemap_scene,
			label_to_entity={
				"Player": {scene=load("res://addons/core/PlayerSpawnPoint.tscn")},
				"Chaser": {scene=load("res://src/shirt/enemies/BlobChaser.tscn")},
				"Walker": {scene=load("res://src/shirt/enemies/BlobWalker.tscn")},
				}})

	rooms = BrickRoom.create_rooms(room_opts)

	for r in rooms:
		r.name = "Room_%s" % room_idx
		room_idx += 1

	var tmap = promote_tilemaps(rooms, {add_borders=true})

	entities = promote_entities(rooms)
	tilemaps.append(tmap)

	new_data_generated.emit({
		rooms=rooms,
		entities=entities,
		tilemaps=tilemaps,
		})

func room_tilemap_coord_to_new_tilemap_coord(room, coord, tilemap):
	var new_pos = room.tilemap.map_to_local(coord) + (room.position / room.tilemap.scale) + room.tilemap.position
	return tilemap.local_to_map(new_pos)

# TODO DRY up on BrickRoom / some other gen helper
func promote_tilemaps(rooms, opts={}):
	var add_borders = opts.get("add_borders")

	var new_cell_coords = []
	var border_cells = []

	var tilemap = tilemap_scene.instantiate()
	# NOTE assumes rooms all have the same scale
	tilemap.scale = rooms[0].tilemap.scale

	var room_rects = []
	for r in rooms:
		var rect = r.tilemap.get_used_rect()
		rect.position = r.tilemap.local_to_map(r.position / r.tilemap.scale + r.tilemap.position)
		room_rects.append(rect)

	for r in rooms:
		var used_cells = r.tilemap.get_used_cells(0)
		var poses = used_cells.map(func(coord):
			return room_tilemap_coord_to_new_tilemap_coord(r, coord, tilemap))
		if add_borders:
			var border_coords = all_tilemap_border_coords(r.tilemap)
			for c in border_coords:
				var coord = room_tilemap_coord_to_new_tilemap_coord(r, c, tilemap)
				var overlaps = false
				for rect in room_rects:
					if rect.has_point(coord):
						overlaps = true
						break
				if not overlaps:
					border_cells.append(coord)

		new_cell_coords.append_array(poses)
		r.remove_child(r.tilemap)
		r.tilemap.queue_free()

	if add_borders:
		new_cell_coords.append_array(border_cells)

	tilemap.set_cells_terrain_connect(0, new_cell_coords, 0, 0)
	tilemap.force_update()

	return tilemap

func tilemap_border_coords(tilemap):
	var rect = tilemap.get_used_rect()
	rect = rect.grow_individual(1, 1, 0, 0)
	var corners = [ # corners
		Vector2i(rect.position.x, rect.position.y),
		Vector2i(rect.position.x + rect.size.x, rect.position.y),
		Vector2i(rect.position.x, rect.position.y + rect.size.y),
		Vector2i(rect.position.x + rect.size.x, rect.position.y + rect.size.y),
		]
	var top_coords = []
	var bottom_coords = []
	for x in range(rect.position.x, rect.position.x + rect.size.x):
		top_coords.append(Vector2i(x, rect.position.y))
		bottom_coords.append(Vector2i(x, rect.position.y + rect.size.y))
	var left_coords = []
	var right_coords = []
	for y in range(rect.position.y, rect.position.y + rect.size.y):
		left_coords.append(Vector2i(rect.position.x, y))
		right_coords.append(Vector2i(rect.position.x + rect.size.x, y))
	return {corners=corners, top_coords=top_coords, bottom_coords=bottom_coords,
		left_coords=left_coords, right_coords=right_coords}

func all_tilemap_border_coords(tilemap):
	return tilemap_border_coords(tilemap).values().reduce(func(acc, xs):
		acc.append_array(xs)
		return acc, [])

func wrap_tilemap(tilemap):
	var coords = tilemap.get_used_cells(0)

	var border_coords = all_tilemap_border_coords(tilemap)
	var fill_coords = []

	coords.append_array(border_coords)
	coords.append_array(fill_coords)
	tilemap.set_cells_terrain_connect(0, coords, 0, 0)
	tilemap.force_update()

func promote_entities(rooms):
	var ents = []
	for room in rooms:
		for ent in room.entities:
			ents.append(ent)
	return ents
