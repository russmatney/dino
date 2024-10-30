@tool
extends Node2D
class_name VaniaRoom

@onready var room_instance = $RoomInstance

const NAV_SOURCE_GROUP = "navigation_sources"

var tile_border_width = 4
var tile_door_width = 4
var room_def: VaniaRoomDef
func set_room_def(def: VaniaRoomDef):
	room_def = def
var tilemap: DinoTileMap
var bg_tilemap: DinoTileMap
var bg_color_rect: ColorRect
var nav_region: NavigationRegion2D
@onready var directional_light: DirectionalLight2D = $DirectionalLight2D
@onready var canvas_modulate: CanvasModulate = $CanvasModulate

var spawn_point_scene = preload("res://src/dino/entities/SpawnPoint.tscn")
var enemy_spawn_points = []
var is_active = false

@export var is_debug = false
@export var debug_room_def: VaniaRoomDef

## enter_tree #####################################################

func _enter_tree():
	ensure_children()

## ready ##############################################################

func _ready():
	if Engine.is_editor_hint():
		request_ready()
		if not room_def:
			room_def = VaniaRoomDef.new()

	if not Engine.is_editor_hint():
		if is_debug:
			debug_room_def.rebuild()
			build_room(debug_room_def)

			if get_node_or_null("Camera2D") == null:
				var cam = Camera2D.new()
				cam.name = "Camera2D"
				var host = PhantomCameraHost.new()
				host.name = "PhantomCameraHost"
				cam.add_child(host)
				add_child(cam)
				cam.set_owner(self)
				host.set_owner(self)

			Log.warn("Fallback player entity hard-coding, better be debugging!")
			Dino.create_new_player({
				entity=Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER),
				})
			Dino.spawn_player({level_node=self,
				genre_type=DinoData.GenreType.SideScroller,
				})

		if not room_def:
			Log.warn("No room_def on vania room!")

		setup_nav_region() # requires main thread
		setup_waves()

## activate_room ##############################################################

func activate_room():
	bg_color_rect.set_visible(true)
	directional_light.set_visible(true)
	canvas_modulate.set_visible(true)

	is_active = true
	spawn_enemy_wave()

## deactivate_room ##############################################################

func deactivate_room():
	bg_color_rect.set_visible(false)
	directional_light.set_visible(false)
	canvas_modulate.set_visible(false)

	is_active = false

## waves ##############################################################

func setup_waves():
	enemy_spawn_points = []
	for ch in get_children():
		if ch is DinoSpawnPoint:
			enemy_spawn_points.append(ch)

var wave = 0
var this_wave = []
func spawn_enemy_wave():
	if enemy_spawn_points.is_empty():
		return

	enemy_spawn_points.shuffle()

	if not this_wave.is_empty():
		Log.info("Current wave not complete, cannot spawn next")
		return

	if wave == room_def.enemy_waves():
		Log.info("all waves complete")
		# open doors? banner notif?
		return

	if wave < room_def.enemy_waves():
		this_wave = []
		wave += 1
		var wave_label
		if wave == 1:
			wave_label = "First"
		elif wave == room_def.enemy_waves():
			wave_label = "Final"
		else:
			wave_label = "Next"
		Dino.notif({type="banner", text="%s Wave" % wave_label,})
		Log.info("starting wave", wave)
		for ent in room_def.enemies().filter(func(ent): return not ent.is_boss()):
			var sp = enemy_spawn_points.filter(func(s):
				return s.spawn_scene == ent.get_scene()
				).pick_random()
			var node = sp.spawn_entity()
			this_wave.append(node)
			node.died.connect(func(e):
				this_wave.erase(e)
				if this_wave.is_empty() and is_active:
					await get_tree().create_timer(1.4).timeout
					spawn_enemy_wave())
			ensure_expected_drops(node)
			add_child(node)

## build room ##############################################################

func build_room(def: VaniaRoomDef, _opts={}):
	# Log.info("building room:", def)
	room_def = def
	ensure_children()
	clear_all_tiles()
	setup_tileset()
	setup_walls_and_doors()
	fill_background_images()
	add_background_tiles()
	add_tile_chunks()
	add_entities()
	add_enemies()
	add_effects()

	# TODO draw roomboxes/color-rects for neighboring map cells

func ensure_children():
	U.ensure_owned_child(self, "tilemap", "TileMap", DinoTileMap)
	U.ensure_owned_child(self, "bg_tilemap", "BackgroundTileMap", DinoTileMap)
	tilemap.add_to_group(NAV_SOURCE_GROUP, true)
	U.ensure_owned_child(self, "nav_region", "NavigationRegion2D", NavigationRegion2D)
	U.ensure_owned_child(self, "bg_color_rect", "BGColorRect", ColorRect)

## setup tilemaps ##############################################################

# TODO use neighbor tileset as background near the door
# TODO pull all this into DinoTileMap
func setup_tileset():
	var primary = room_def.get_primary_tiles()
	if primary:
		var tmap = primary.get_scene().instantiate()
		tilemap.set_tile_set(tmap.get_tile_set().duplicate(true))
		tilemap.chunk_defs = primary.get_grid_defs()

	var secondary = room_def.get_secondary_tiles()
	if secondary:
		var tmap = secondary.get_scene().instantiate()
		bg_tilemap.set_tile_set(tmap.get_tile_set().duplicate(true))
		bg_tilemap.chunk_defs = secondary.get_grid_defs()

		Reptile.disable_collisions(bg_tilemap)
		Reptile.disable_occlusion(bg_tilemap)

		# TODO support multiple bg_tilemap layers

		# darken, fade
		bg_tilemap.modulate.r -= 0.4
		bg_tilemap.modulate.g -= 0.4
		bg_tilemap.modulate.b -= 0.4
		bg_tilemap.modulate.a = 0.4
		bg_tilemap.set_z_index(-5)
	else:
		Log.warn("cannot setup tileset for room_def", room_def)

func clear_all_tiles():
	tilemap.clear()
	bg_tilemap.clear()

func clear_tilemap_tiles():
	tilemap.clear()

func clear_background_tiles():
	bg_tilemap.clear()

## walls and doors ##############################################################

# Draws a border around the room
# cuts away space for 'doors' between neighboring rooms
func setup_walls_and_doors():
	var door_tile_coords = get_door_tile_coords()

	clear_tilemap_tiles()

	fill_tilemap_borders({skip_cells=door_tile_coords})

	tilemap.mix_terrains()
	tilemap.update_internals()

func get_door_tile_coords():
	var coords = []
	for door in room_def.doors:
		var tile_coords = get_tile_coords_for_doorway(door)
		coords.append_array(tile_coords)
	return coords

func is_border_coord(cell_rect: Rect2i, coord: Vector2i, opts={}):
	var offset = opts.get("offset", 0)
	var skip_borders = opts.get("skip_borders", [
		Vector2i.LEFT,
		Vector2i.RIGHT,
		Vector2i.UP,
		Vector2i.DOWN,
		])
	# corners are always filled, borders are opt-out via skip_borders

	var is_left_border = abs(cell_rect.position.x - coord.x) < tile_border_width - offset
	var is_right_border = abs(cell_rect.end.x - coord.x) <= tile_border_width - offset
	var is_top_border = abs(cell_rect.position.y - coord.y) < tile_border_width - offset
	var is_bottom_border = abs(cell_rect.end.y - coord.y) <= tile_border_width - offset

	var is_top_left_corner = (
		abs(cell_rect.position.x - coord.x) < tile_border_width - offset and
		abs(cell_rect.position.y - coord.y) < tile_border_width - offset)
	var is_top_right_corner = (
		abs(cell_rect.end.x - coord.x) <= tile_border_width - offset and
		abs(cell_rect.position.y - coord.y) < tile_border_width - offset)
	var is_bottom_left_corner = (
		abs(cell_rect.position.x - coord.x) < tile_border_width - offset and
		abs(cell_rect.end.y - coord.y) <= tile_border_width - offset)
	var is_bottom_right_corner = (
		abs(cell_rect.end.x - coord.x) <= tile_border_width - offset and
		abs(cell_rect.end.y - coord.y) <= tile_border_width - offset)

	return (is_top_left_corner and not (Vector2i.LEFT + Vector2i.UP) in skip_borders) \
		or (is_top_right_corner and not (Vector2i.RIGHT + Vector2i.UP) in skip_borders) \
		or (is_bottom_left_corner and not (Vector2i.LEFT + Vector2i.DOWN) in skip_borders) \
		or (is_bottom_right_corner and not (Vector2i.RIGHT + Vector2i.DOWN) in skip_borders) \
		or (is_left_border and not Vector2i.LEFT in skip_borders) \
		or (is_right_border and not Vector2i.RIGHT in skip_borders) \
		or (is_top_border and not Vector2i.UP in skip_borders) \
		or (is_bottom_border and not Vector2i.DOWN in skip_borders)

func internal_borders(cell, cells):
	var borders = []
	for c in cells:
		if c == cell:
			continue
		if room_def.is_neighboring_cell(c, cell):
			var diff = c - cell
			borders.append(Vector2i(diff.x, diff.y))
	return borders

func fill_tilemap_borders(opts={}):
	var t_cells: Array[Vector2i] = []
	# do we need to normalize 'local_cells'?
	for cell in room_def.local_cells:
		var rect = Rect2(Vector2(cell.x, cell.y) * MetSys.settings.in_game_cell_size, MetSys.settings.in_game_cell_size)
		var recti = Reptile.rect_to_local_rect(tilemap, rect)
		recti.size += Vector2i.DOWN # weird!

		var skip_borders = internal_borders(cell, room_def.local_cells)
		skip_borders.append_array(room_def.skip_borders())

		var border_cells = Reptile.cells_in_rect(recti).filter(func(coord):
			if opts.get("skip_cells"):
				if opts.get("skip_cells").has(coord):
					return false
			return is_border_coord(recti, coord, {skip_borders=skip_borders}))

		t_cells.append_array(border_cells)

	tilemap.fill_coords(t_cells)

func get_tile_coords_for_doorway(door):
	var this_cell = door[0]
	var neighbor_cell = door[1]
	var wall = neighbor_cell - this_cell
	wall = Vector2(wall.x, wall.y)

	# local rect (position, size) of the cell for the doorway
	var cell_rect = room_def.get_map_cell_rect(this_cell)

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

	return Reptile.cells_in_local_rect(tilemap, door_rect)

## background images ##############################################################

func fill_background_images(_opts={}):
	var cells = room_def.map_cells
	if cells.is_empty():
		Log.warn("falling back to local_cells, better be in debug mode!")
		cells = room_def.local_cells
		room_def.calc_cell_meta({cells=cells})
	if cells.is_empty():
		Log.warn("could not create background rect, no cells!")

	var bg_color = room_def.get_bg_color()

	# color bg outside of local cells
	bg_color_rect.color = bg_color

	# color rects inside local cells
	for map_cell in cells:
		var rect = room_def.get_map_cell_rect(map_cell)
		var crect = U.add_color_rect(self, {rect=rect, color=bg_color, name=str(map_cell, "BGRect")})
		crect.set_owner(self)
		crect.set_z_index(-10)

## setup nav region ##############################################################

func setup_nav_region():
	var rect = room_def.get_rect()

	var nav_mesh = NavigationPolygon.new()
	var bounding_outline = PackedVector2Array([
		rect.position,
		Vector2(rect.position.x, rect.end.y),
		rect.end,
		Vector2(rect.end.x, rect.position.y),
		# Vector2(0, 0), Vector2(0, 50), Vector2(50, 50), Vector2(50, 0)
		])
	nav_mesh.add_outline(bounding_outline)
	# TODO avoid collisions in tilemaps
	nav_mesh.set_source_geometry_mode(NavigationPolygon.SOURCE_GEOMETRY_GROUPS_WITH_CHILDREN)
	nav_mesh.set_source_geometry_group_name(NAV_SOURCE_GROUP)
	nav_region.set_navigation_polygon(nav_mesh)
	nav_region.bake_navigation_polygon()

## add_tile_chunks ##############################################################

var logged_tile_pos = false

func add_tile_chunks(tmap=null, opts={}):
	if tmap == null:
		tmap = tilemap

	var grids = tmap.chunk_defs.grids_with_flag("tile_chunk")
	if grids.is_empty():
		Log.warn("No tile chunks!")
		return
	logged_tile_pos = false

	# get existing tiles based on the main tilemap
	var tmap_data = build_tilemap_data()

	var tile_coords: Array[Vector2i] = []

	var count_chunks_added = 0
	var count_chunks_attempted = 0
	var count_chunks_requested = opts.get("count", 2)
	var attempt_max = count_chunks_requested * 4
	while (count_chunks_added < count_chunks_requested
		# safety hatch, probably cases where nothing fits
		and count_chunks_attempted < attempt_max):
		var tile_chunk = grids.pick_random()
		var chunk_rotations = tile_chunk.get_rotations()
		var found_match = false
		for chunk in chunk_rotations:
			if found_match:
				break

			var start_coords = possible_positions(tmap_data,
				chunk.get_shape_dict({drop_entity="NewTile"}))
			if start_coords.is_empty():
				continue

			found_match = true
			var start_coord = start_coords.pick_random()

			if opts.get("include_existing_tiles", false):
				for e_coord in chunk.get_coords_for_entity("Tile"):
					tile_coords.append(e_coord + start_coord)

			for e_coord in chunk.get_coords_for_entity("NewTile"):
				tile_coords.append(e_coord + start_coord)

		if found_match:
			count_chunks_added += 1
		count_chunks_attempted += 1

	if count_chunks_added < count_chunks_requested:
		Log.warn("Couldn't match requested chunks in attempts:", count_chunks_attempted)

	if not tile_coords.is_empty():
		tmap.fill_coords(tile_coords)
		tmap.mix_terrains()
		tmap.update_internals()

## background tiles ##############################################################

func add_background_tiles(opts={}):
	U.ensure_default(opts, "count", 10)
	U.ensure_default(opts, "include_existing_tiles", true)
	add_tile_chunks(bg_tilemap, opts)

## add_enemies/entities ##############################################################

# adds an entity for the passed DinoEntity or DinoEnemy
# if waves are specified, adds a spawn_point instead.
func add_entity(ent):
	var use_spawn_point = false
	if (ent is DinoEnemy and not ent.is_boss() and
		room_def.enemy_waves() > 0):
		use_spawn_point = true

	var tmap_data = build_tilemap_data()

	var label = ent.get_label()
	var grids = ent.get_grid_defs()
	if grids.is_empty():
		# TODO fallback to putting it in the center?
		Log.warn("No grids for ent or enemy, skipping: ", ent)
		return
	var grid = grids.pick_random()

	# find place to put entity
	var shape_dict = grid.get_shape_dict({drop_entity=label})

	# TODO exclude doorways
	var start_coords = possible_positions(tmap_data, shape_dict)

	for e_coord in grid.get_coords_for_entity(label):
		if start_coords.is_empty():
			Log.warn("No position found for entity!", ent)
			continue

		var spawn_count = 1
		if use_spawn_point:
			spawn_count = 4

		start_coords.shuffle()
		for i in range(spawn_count):
			if i >= len(start_coords):
				Log.warn("not enough start_coords for spawn_count, breaking")
				break
			var start_coord = start_coords[i]

			var node
			if use_spawn_point:
				node = spawn_point_scene.instantiate()
				node.spawn_scene = ent.get_scene()
			else:
				node = ent.get_scene().instantiate()
				ensure_expected_drops(node)

			var pos = tilemap.map_to_local(e_coord + start_coord)
			node.position = pos

			add_child(node)
			node.set_owner(self)

func add_enemies():
	for enemy in room_def.enemies():
		add_entity(enemy)

func add_entities():
	for ent in room_def.entities():
		add_entity(ent)

func ensure_expected_drops(node):
	if "drops" in node.get_property_list().map(func(p): return p.name):
		if node.drops.is_empty():
			var drops = room_def.get_drops()
			if drops.is_empty():
				drops = [DropData.new()]
			node.drops.assign([drops.pick_random()])

## add_effects ##############################################################

func add_effects():
	for eff in room_def.effects():
		eff.add_to_room(self)

## fit helpers ##############################################################

func build_tilemap_data():
	var tmap_data = {}

	for cell in room_def.local_cells:
		var rect = Reptile.rect_to_local_rect(tilemap, room_def.get_local_rect(Vector2i(cell.x, cell.y)))

		for t_cell in Reptile.cells_in_rect(rect):
			tmap_data[t_cell] = null
		for t_cell in tilemap.get_used_cells():
			tmap_data[t_cell] = ["Tile"]
	return tmap_data

func possible_positions(tmap_data, entity_shape):
	var positions = []
	var rect = Reptile.rect_to_local_rect(tilemap, room_def.get_rect())
	for coord in tmap_data.keys():
		# skip all but innermost border
		if is_border_coord(rect, coord, {offset=1}):
			continue
		if is_fit(coord, tmap_data, entity_shape):
			positions.append(coord)
	return positions

func is_fit(coord: Vector2i, tmap_data, entity_shape):
	# TODO handle required empty vs wildcard spaces
	for e_coord in entity_shape.keys():
		var e_val = entity_shape.get(e_coord)
		var t_val = tmap_data.get(coord + e_coord)
		if not tmap_data.has(coord + e_coord): # tile does not exist (bottom of map)
			return false
		if e_val != t_val:
			return false
	return true
