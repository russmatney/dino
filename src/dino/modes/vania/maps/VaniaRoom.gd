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

func is_border_coord(rect, coord):
	return (abs(rect.position.x - coord.x) < tile_border_width) \
		or (abs(rect.end.x - coord.x) <= tile_border_width) \
		or (abs(rect.position.y - coord.y) < tile_border_width) \
		or (abs(rect.end.y - coord.y) <= tile_border_width)

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

## add_entities ##############################################################

func build_tilemap_data():
	var tmap_data = {}
	for cell in tilemap.get_used_cells(0):
		tmap_data[cell] = ["Tile"]
	return tmap_data

func add_entities():
	Log.pr("Adding entities", room_def.entities)

	var tmap_data = build_tilemap_data()

	for ent in room_def.entities:
		var entity_opts = room_def.label_to_entity.get(ent)
		var grids = room_def.entity_defs.grids_with_entity(ent)
		var grid = grids.pick_random()
		Log.pr("grid with ent", grid, grid.shape, grid.rect(), grid.get_shape_dict())

		# find place to put entity

func possible_positions(tmap_data, entity_shape):
	var offset = Vector2.ZERO
	var positions = []

	# TODO impl

	return positions
