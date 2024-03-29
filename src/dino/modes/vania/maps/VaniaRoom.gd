@tool
extends Node2D

@onready var room_instance = $RoomInstance

@export var tilemap_scenes: Array[PackedScene] = []

var tile_border_width = 4
var tile_door_width = 4
var room_def: VaniaRoomDef
func set_room_def(def: VaniaRoomDef):
	room_def = def
var tilemap: TileMap

## init ###############################################################

func _enter_tree():
	ensure_tilemap()

func ensure_tilemap():
	if tilemap == null:
		tilemap = get_node_or_null("TileMap")
	if tilemap == null and not tilemap_scenes.is_empty():
		tilemap = tilemap_scenes[0].instantiate()
		add_child(tilemap)
		tilemap.set_owner(self)

## ready ##############################################################

func _ready():
	if Engine.is_editor_hint():
		request_ready()
		if not room_def:
			room_def = VaniaRoomDef.new()
	else:
		if not room_def:
			Log.warn("No room_def on vania room!")

	setup_walls_and_doors()
	add_tile_chunks()
	add_entities()

## setup_walls_and_doors ##############################################################

# Draws a border around the room
# cuts away space for 'doors' between neighboring rooms
# TODO rewrite to not need the room_instance (and work before _ready())
func setup_walls_and_doors():
	var neighbors = get_possible_neighbor_doors()
	var door_cells = []
	for ngbr in neighbors:
		door_cells.append_array(get_door_cells_to_neighbor(ngbr))
	for c in door_cells:
		tilemap.erase_cell(0, c)

	fill_tilemap_borders({skip_cells=door_cells})

	tilemap.force_update()

func is_border_coord(rect, coord, offset=0):
	return (abs(rect.position.x - coord.x) < tile_border_width - offset) \
		or (abs(rect.end.x - coord.x) <= tile_border_width - offset) \
		or (abs(rect.position.y - coord.y) < tile_border_width - offset) \
		or (abs(rect.end.y - coord.y) <= tile_border_width - offset)

func fill_tilemap_borders(opts={}):
	var rect = Reptile.rect_to_local_rect(tilemap, Rect2(Vector2(), room_instance.get_size()))
	var t_cells = Reptile.cells_in_rect(rect).filter(func(coord):
		if opts.get("skip_cells"):
			if opts.get("skip_cells").has(coord):
				return false
		return is_border_coord(rect, coord))

	tilemap.set_cells_terrain_connect(0, t_cells, 0, 0)

func is_neighbor(a: Vector3i, b: Vector3i) -> bool:
	if a.x - b.x == 0:
		return abs(a.y - b.y) == 1
	if a.y - b.y == 0:
		return abs(a.x - b.x) == 1
	return false

func get_possible_neighbor_doors():
	var room_cells = MetSys.map_data.get_cells_assigned_to(room_instance.room_name)
	var neighbors = []

	var neighbor_paths = room_instance.get_neighbor_rooms(false)
	for p in neighbor_paths:
		neighbors.append({path=p, cells=MetSys.map_data.get_cells_assigned_to(p)})

	for ngbr in neighbors:
		ngbr.possible_doors = []
		for n_cell in ngbr.cells:
			for r_cell in room_cells:
				if is_neighbor(n_cell, r_cell):
					ngbr.possible_doors.append([r_cell, n_cell])

	return neighbors

func get_door_cells_to_neighbor(neighbor):
	var door = neighbor.possible_doors.pick_random()
	var wall = door[1] - door[0]
	wall = Vector2(wall.x, wall.y)

	var room_cell = room_instance.to_local_cell(door[0])
	var cell_rect = room_instance.get_cell_rect(room_cell)

	var cell_width = MetSys.settings.in_game_cell_size.x
	var cell_height = MetSys.settings.in_game_cell_size.y

	var border_width = tile_border_width * room_def.tile_size
	var door_width = tile_door_width * room_def.tile_size

	var door_rect = Rect2()
	match wall:
		Vector2.LEFT:
			door_rect.position = cell_rect.position
			door_rect.position.y += (cell_height - door_width) / 2
			door_rect.size = Vector2(border_width, door_width)
		Vector2.RIGHT:
			door_rect.position = cell_rect.position + Vector2.RIGHT * (cell_width - border_width)
			door_rect.position.y += (cell_height - door_width) / 2
			door_rect.size = Vector2(border_width, door_width)
		Vector2.UP:
			door_rect.position = cell_rect.position
			door_rect.position.x += (cell_width - door_width) / 2
			door_rect.size = Vector2(door_width, border_width)
		Vector2.DOWN:
			door_rect.position = Vector2(cell_rect.position.x, cell_rect.end.y)
			door_rect.position.y -= border_width
			door_rect.position.x += (cell_width - door_width) / 2
			door_rect.size = Vector2(door_width, border_width + room_def.tile_size)

	var rect = Reptile.rect_to_local_rect(tilemap, door_rect)
	return Reptile.cells_in_rect(rect)

## add_tile_chunks ##############################################################

func add_tile_chunks():
	Log.pr("Adding tile chunks")
	var grids = room_def.entity_defs.grids_with_flag("tile_chunk")
	if grids.is_empty():
		Log.warn("No tile chunks!")
		return

	var tmap_data = build_tilemap_data()

	# var count = [1, 2, 3].pick_random()
	var count = 3

	var tile_coords = []
	for i in range(count):
		var tile_chunk = grids.pick_random()
		var start_coords = possible_positions(tmap_data,
			tile_chunk.get_shape_dict({drop_entity="NewTile"}))
		if start_coords.is_empty():
			Log.warn("No position found for tile chunk!", tile_chunk)
			# TODO try a different chunk, maybe flip/rotate it
			continue
		var start_coord = start_coords.pick_random()

		for e_coord in tile_chunk.get_coords_for_entity("NewTile"):
			tile_coords.append(e_coord + start_coord)

	tilemap.set_cells_terrain_connect(0, tile_coords, 0, 0)

	tilemap.force_update()


## add_entities ##############################################################

func add_entities():
	Log.pr("Adding entities", room_def.entities)

	var tmap_data = build_tilemap_data()

	for ent in room_def.entities:
		var entity_opts = room_def.label_to_entity.get(ent)
		var grids = room_def.entity_defs.grids_with_entity(ent)
		var grid = grids.pick_random()

		# find place to put entity
		var shape_dict = grid.get_shape_dict({drop_entity=ent})

		# TODO exclude doorways
		var start_coords = possible_positions(tmap_data, shape_dict)

		for e_coord in grid.get_coords_for_entity(ent):
			if start_coords.is_empty():
				Log.warn("No position found for entity!", ent)
				continue
			var start_coord = start_coords.pick_random()
			start_coords.erase(start_coord)

			# place entity at random start cord
			var pos = tilemap.map_to_local(e_coord + start_coord)
			var entity = entity_opts.scene.instantiate()
			entity.position = pos
			add_child(entity)

## fit helpers ##############################################################

func build_tilemap_data():
	var tmap_data = {}
	for cell in Reptile.cells_in_rect(tilemap.get_used_rect()):
		tmap_data[cell] = null
	for cell in tilemap.get_used_cells(0):
		tmap_data[cell] = ["Tile"]
	return tmap_data

func possible_positions(tmap_data, entity_shape):
	var positions = []
	var rect = Reptile.rect_to_local_rect(tilemap, Rect2(Vector2(), room_instance.get_size()))
	for coord in tmap_data.keys():
		# skip all but innermost border
		if is_border_coord(rect, coord, 1):
			continue
		if is_fit(coord, tmap_data, entity_shape):
			positions.append(coord)
	return positions

func is_fit(coord: Vector2i, tmap_data, entity_shape):
	for e_coord in entity_shape.keys():
		var e_val = entity_shape.get(e_coord)
		var t_val = tmap_data.get(coord + e_coord)
		if e_val != t_val:
			return false
	return true
