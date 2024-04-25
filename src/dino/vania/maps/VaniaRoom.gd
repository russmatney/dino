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
var tilemap: TileMap
var bg_tilemap: TileMap
var bg_color_rect: ColorRect
var nav_region: NavigationRegion2D

@export var is_debug = false
@export var debug_room_def: VaniaRoomDef

## enter_tree #####################################################

func _enter_tree():
	ensure_tilemaps()
	U.ensure_owned_child(self, "bg_color_rect", "BGColorRect", ColorRect)

## ready ##############################################################

func _ready():
	if Engine.is_editor_hint():
		request_ready()
		if not room_def:
			room_def = VaniaRoomDef.new()

	if not Engine.is_editor_hint():
		if is_debug:
			debug_room_def.reapply_constraints()
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

			Dino.create_new_player({
				genre_type=DinoData.GenreType.SideScroller,
				entity=Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER),
				})
			Dino.spawn_player({level_node=self})


		if not room_def:
			Log.warn("No room_def on vania room!")

		setup_nav_region() # requires main thread

## build room ##############################################################

func build_room(def: VaniaRoomDef, opts={}):
	# Log.info("building room:", def)
	room_def = def
	clear_all_tiles()
	setup_tileset()
	setup_walls_and_doors(opts)
	fill_background_images()
	add_background_tiles()
	# add_tile_chunks()
	add_entities()
	add_enemies()
	add_effects()

## setup tilemaps ##############################################################

func ensure_tilemaps():
	U.ensure_owned_child(self, "tilemap", "TileMap", TileMap)
	U.ensure_owned_child(self, "bg_tilemap", "BackgroundTileMap", TileMap)
	tilemap.add_to_group(NAV_SOURCE_GROUP, true)
	U.ensure_owned_child(self, "nav_region", "NavigationRegion2D", NavigationRegion2D)

# TODO use neighbor tileset as background near the door
func setup_tileset():
	ensure_tilemaps()
	var primary_tilemap = room_def.get_primary_tilemap()
	if primary_tilemap:
		var primary = primary_tilemap.instantiate()
		tilemap.set_tileset(primary.get_tileset().duplicate(true))

	var secondary_tilemap = room_def.get_secondary_tilemap()
	if secondary_tilemap:
		var secondary = secondary_tilemap.instantiate()
		bg_tilemap.set_tileset(secondary.get_tileset().duplicate(true))
		Reptile.disable_collisions(bg_tilemap)

		# TODO support multiple bg_tilemap layers
		# TODO darken instead of alpha
		bg_tilemap.modulate.a = 0.3
		bg_tilemap.set_z_index(-5)
	else:
		Log.warn("cannot setup tileset without room_def.tilemap_scenes")

func clear_all_tiles():
	ensure_tilemaps()
	tilemap.clear()
	bg_tilemap.clear()

func clear_tilemap_tiles():
	tilemap.clear()

func clear_background_tiles():
	bg_tilemap.clear()

## walls and doors ##############################################################

# Draws a border around the room
# cuts away space for 'doors' between neighboring rooms
func setup_walls_and_doors(opts={}):
	var door_tile_coords = get_door_tile_coords(opts)

	# TODO include neighbor data when building rooms
	# but also, support updating doors when new neighbors are created
	clear_tilemap_tiles()
	fill_tilemap_borders({skip_cells=door_tile_coords})

	tilemap.force_update()

func get_door_tile_coords(opts={}):
	var coords = []
	for door in room_def.get_doors(opts):
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
	return (abs(cell_rect.position.x - coord.x) < tile_border_width - offset and
			abs(cell_rect.position.y - coord.y) < tile_border_width - offset) \
		or (abs(cell_rect.end.x - coord.x) <= tile_border_width - offset and
			abs(cell_rect.position.y - coord.y) < tile_border_width - offset) \
		or (abs(cell_rect.position.x - coord.x) < tile_border_width - offset and
			abs(cell_rect.end.y - coord.y) <= tile_border_width - offset) \
		or (abs(cell_rect.end.x - coord.x) <= tile_border_width - offset and
			abs(cell_rect.end.y - coord.y) <= tile_border_width - offset) \
		or (abs(cell_rect.position.x - coord.x) < tile_border_width - offset and not Vector2i.LEFT in skip_borders) \
		or (abs(cell_rect.end.x - coord.x) <= tile_border_width - offset and not Vector2i.RIGHT in skip_borders) \
		or (abs(cell_rect.position.y - coord.y) < tile_border_width - offset and not Vector2i.UP in skip_borders) \
		or (abs(cell_rect.end.y - coord.y) <= tile_border_width - offset and not Vector2i.DOWN in skip_borders)

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
	var t_cells = []
	# do we need to normalize 'local_cells'?
	for cell in room_def.local_cells:
		var rect = Rect2(Vector2(cell.x, cell.y) * MetSys.settings.in_game_cell_size, MetSys.settings.in_game_cell_size)
		var recti = Reptile.rect_to_local_rect(tilemap, rect)
		recti.size += Vector2i.DOWN # weird!

		var skip_borders = internal_borders(cell, room_def.local_cells)

		var border_cells = Reptile.cells_in_rect(recti).filter(func(coord):
			if opts.get("skip_cells"):
				if opts.get("skip_cells").has(coord):
					return false
			return is_border_coord(recti, coord, {skip_borders=skip_borders}))

		t_cells.append_array(border_cells)

	tilemap.set_cells_terrain_connect(0, t_cells, 0, 0)

func get_tile_coords_for_doorway(map_cell_pair):
	var wall = map_cell_pair[1] - map_cell_pair[0]
	wall = Vector2(wall.x, wall.y)

	# local rect (position, size) of the cell for the doorway
	var cell_rect = room_def.get_map_cell_rect(map_cell_pair[0])

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

var bg_color = Color(0.5, 0.3, 0.6, 1.0)

func fill_background_images(_opts={}):
	for map_cell in room_def.map_cells:
		var rect = room_def.get_map_cell_rect(map_cell)
		var crect = U.add_color_rect(self, {rect=rect, color=bg_color, name=str(map_cell, "BGRect")})
		crect.set_owner(self)
		crect.set_z_index(-10)

## background tiles ##############################################################

var logged_bg_tile_pos = false

# this depends on build_tilemap_data, which expects the base tilemap to have borders already
func add_background_tiles(opts={}):
	if not room_def.tile_defs:
		return
	var grids = room_def.tile_defs.grids_with_flag("tile_chunk")
	if grids.is_empty():
		Log.warn("No tile chunks!")
		return

	var tmap_data = build_tilemap_data() # this inits based on the base tilemap (walls/doors)

	var tile_coords = []
	for i in range(opts.get("count", 100)):
		var tile_chunk = grids.pick_random()
		var start_coords = possible_positions(tmap_data,
			tile_chunk.get_shape_dict({drop_entity="NewTile"}))
		if start_coords.is_empty():
			if not logged_bg_tile_pos:
				logged_bg_tile_pos = true
				Log.warn("No position found for background tile!")
			# TODO try a different chunk, maybe flip/rotate it
			continue
		var start_coord = start_coords.pick_random()

		if opts.get("re_add_existing_tiles", false):
			for e_coord in tile_chunk.get_coords_for_entity("Tile"):
				tile_coords.append(e_coord + start_coord)
		for e_coord in tile_chunk.get_coords_for_entity("NewTile"):
			tile_coords.append(e_coord + start_coord)

	bg_tilemap.set_cells_terrain_connect(0, tile_coords, 0, 0)

	bg_tilemap.force_update()

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

func add_tile_chunks(opts={}):
	var grids = room_def.tile_defs.grids_with_flag("tile_chunk")
	if grids.is_empty():
		Log.warn("No tile chunks!")
		return

	var tmap_data = build_tilemap_data()

	var tile_coords = []
	for i in range(opts.get("count", 10)):
		var tile_chunk = grids.pick_random()
		var start_coords = possible_positions(tmap_data,
			tile_chunk.get_shape_dict({drop_entity="NewTile"}))
		if start_coords.is_empty():
			if not logged_tile_pos:
				logged_tile_pos = true
				Log.warn("No position found for tile chunk!")
			# TODO try a different chunk, maybe flip/rotate it
			continue
		var start_coord = start_coords.pick_random()

		for e_coord in tile_chunk.get_coords_for_entity("NewTile"):
			tile_coords.append(e_coord + start_coord)

	if not tile_coords.is_empty():
		tilemap.set_cells_terrain_connect(0, tile_coords, 0, 0)
		tilemap.force_update()

## add_enemies/entities ##############################################################

func add_entity(ent):
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
		var start_coord = start_coords.pick_random()
		start_coords.erase(start_coord)

		# place entity at random start cord
		var pos = tilemap.map_to_local(e_coord + start_coord)
		var enemy_node = ent.get_scene().instantiate()
		enemy_node.position = pos
		add_child(enemy_node)
		enemy_node.set_owner(self)

func add_enemies():
	for enemy in room_def.enemies:
		add_entity(enemy)

func add_entities():
	for ent in room_def.entities:
		add_entity(ent)

## add_effects ##############################################################

func add_effects():
	for eff in room_def.effects:
		# TODO all roomeffects have this method, need a flag
		if eff.has_method("add_at_cell"):
			for cell in room_def.local_cells:
				var rect = room_def.get_local_rect(Vector2i(cell.x, cell.y))
				eff.add_at_cell(self, rect)

				# var rect_top_center = rect.position
				# var half_x_size = rect.size.x / 2
				# rect_top_center += Vector2.RIGHT * half_x_size
				# var effect = eff.instantiate()
				# effect.position = rect_top_center
				# effect.process_material.emission_box_extents.x = half_x_size
				# add_child(effect)
				# effect.set_owner(self)

## fit helpers ##############################################################

func build_tilemap_data():
	var tmap_data = {}

	for cell in room_def.local_cells:
		var rect = Reptile.rect_to_local_rect(tilemap, room_def.get_local_rect(Vector2i(cell.x, cell.y)))

		for t_cell in Reptile.cells_in_rect(rect):
			tmap_data[t_cell] = null
		for t_cell in tilemap.get_used_cells(0):
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
