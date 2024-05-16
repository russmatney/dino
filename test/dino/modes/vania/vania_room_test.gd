extends GdUnitTestSuite
class_name VaniaRoomTest

## tilemap walls ################################################

func test_build_room_sets_tilemap_borders():
	var room = auto_free(VaniaRoom.new())
	var def = VaniaRoomDef.new({input=MapInput.spaceship().merge(MapInput.small_room_shape())})

	def.map_cells = [Vector3i(0, 0, 0)]

	room.set_room_def(def)
	room.ensure_children()
	room.setup_tileset()
	room.fill_tilemap_borders()
	room.tilemap.force_update()

	var map_cell_rect = def.get_map_cell_rect(def.map_cells[0])
	var tiles_start = room.tilemap.local_to_map(map_cell_rect.position)
	var tiles_end = room.tilemap.local_to_map(map_cell_rect.end)
	tiles_end -= Vector2i.ONE

	var tmap_cells = room.tilemap.get_used_cells(0)
	assert_array(tmap_cells).is_not_empty()

	assert_array(tmap_cells).contains([Vector2i(), Vector2i(0, 1), Vector2i(1,0)])
	assert_array(tmap_cells).contains([
		tiles_end,
		tiles_end + Vector2i(0, -1),
		tiles_end + Vector2i(-1, 0),
		])
	assert_array(tmap_cells).contains([Vector2i(tiles_start.x, tiles_end.y),])
	assert_array(tmap_cells).contains([Vector2i(tiles_end.x, tiles_start.y),])

func test_build_room_walls_concave_shape():
	var shape = [Vector3i(0, 0, 0), Vector3i(0, 1, 0), Vector3i(1, 0, 0)]

	var room = auto_free(VaniaRoom.new())
	var def = VaniaRoomDef.new({input=MapInput.spaceship().merge(MapInput.has_room({shape=shape}))})

	def.map_cells = shape

	room.set_room_def(def)
	room.ensure_children()
	room.setup_tileset()
	room.fill_tilemap_borders()
	room.tilemap.force_update()

	var tmap_cells = room.tilemap.get_used_cells(0)

	var expected_full_borders = {
		Vector3i(0, 0, 0): [Vector2i.UP, Vector2i.LEFT],
		Vector3i(1, 0, 0): [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN],
		Vector3i(0, 1, 0): [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.DOWN],
		}

	for cell in shape:
		var map_cell_rect = def.get_map_cell_rect(cell)
		var cells_rect = Reptile.rect_to_local_rect(room.tilemap, map_cell_rect)

		var left_border = range(cells_rect.position.y, cells_rect.end.y).map(func(y): return Vector2i(cells_rect.position.x, y))
		var top_border = range(cells_rect.position.x, cells_rect.end.x).map(func(x): return Vector2i(x, cells_rect.position.y))
		var bottom_border = range(cells_rect.position.x, cells_rect.end.x).map(func(x): return Vector2i(x, cells_rect.end.y - 1))
		var right_border = range(cells_rect.position.y, cells_rect.end.y).map(func(y): return Vector2i(cells_rect.end.x - 1, y))

		assert_array(expected_full_borders[cell]).is_not_empty()

		for dir in expected_full_borders[cell]:
			match dir:
				Vector2i.UP:
					assert_array(tmap_cells).contains(top_border)
				Vector2i.DOWN:
					assert_array(tmap_cells).contains(bottom_border)
				Vector2i.LEFT:
					assert_array(tmap_cells).contains(left_border)
				Vector2i.RIGHT:
					assert_array(tmap_cells).contains(right_border)

## tilemap doors ################################################

func test_build_room_sets_tilemap_doors():
	var room = auto_free(VaniaRoom.new())
	var def = VaniaRoomDef.new()
	MapInput.apply(MapInput.spaceship().merge(MapInput.small_room_shape()), def)

	def.map_cells = [Vector3i(0, 0, 0)]

	room.set_room_def(def)
	room.ensure_children()
	room.setup_tileset()

	var neighbor_data = [
		{map_cells=[Vector3i(1, 0, 0)]}, # on the right
		]

	room.setup_walls_and_doors({neighbor_data=neighbor_data})

	var map_cell_rect = def.get_map_cell_rect(def.map_cells[0])
	var tiles_start = room.tilemap.local_to_map(map_cell_rect.position)
	var tiles_end = room.tilemap.local_to_map(map_cell_rect.end)
	tiles_end -= Vector2i.ONE

	var tmap_cells = room.tilemap.get_used_cells(0)
	assert_array(tmap_cells).is_not_empty()

	# right bottom corner
	assert_array(tmap_cells).contains([
		tiles_end,
		tiles_end + Vector2i(0, -1),
		tiles_end + Vector2i(-1, 0),
		])
	# right top corner
	assert_array(tmap_cells).contains([Vector2i(tiles_end.x, tiles_start.y),])

	# right middle should be a gap!
	# var middle_y = (tiles_end.y - tiles_start.y) / 2
	# TODO less hard-codey version of this!
	# assert_array(tmap_cells).not_contains([
	# 	Vector2i(tiles_end.x, 5), Vector2i(tiles_end.x, 7),
	# 	Vector2i(tiles_end.x, 10), Vector2i(tiles_end.x, 12),
	# 	])

## tilemap backgrounds ################################################

# TODO rewrite to consume an on the fly DinoTile
# (no more tile_defs passed to VaniaRoomDef)
# func test_build_room_adds_tile_backgrounds():
# 	var tile_defs = GridParser.parse({contents="""
# name Tile Chunks

# ==============
# LEGEND
# ==============

# x = Tile
# n = NewTile

# ==============
# CHUNKS
# ==============

# name Tile
# tile_chunk

# xxx
# xn.
# x..
# 	"""})

# 	var room = auto_free(VaniaRoom.new())
# 	var def = VaniaRoomDef.new({tile_defs=tile_defs})
# 	MapInput.apply(MapInput.spaceship().merge(MapInput.small_room_shape()), def)

# 	room.set_room_def(def)
# 	room.setup_tileset()
# 	room.setup_walls_and_doors()

# 	var bg_tmap_cells = room.bg_tilemap.get_used_cells(0)
# 	assert_array(bg_tmap_cells).is_empty()

# 	room.add_background_tiles({count=1})

# 	var new_tmap_cells = room.bg_tilemap.get_used_cells(0)

# 	assert_int(len(new_tmap_cells) - len(bg_tmap_cells)).is_equal(1) # added one tile

# 	var expected_corner_tile = Vector2i.ONE * room.tile_border_width
# 	assert_array(new_tmap_cells).contains([expected_corner_tile])
# 	# TODO assert the new tile's position

# ## tile chunks ################################################

# func test_build_room_adds_tile_chunks():
# 	var tile_defs = GridParser.parse({contents="""
# name Tile Chunks

# ==============
# LEGEND
# ==============

# x = Tile
# n = NewTile

# ==============
# CHUNKS
# ==============

# name Tile
# tile_chunk

# xxx
# xn.
# x..
# 	"""})

# 	var room = auto_free(VaniaRoom.new())
# 	var def = VaniaRoomDef.new({tile_defs=tile_defs})
# 	MapInput.apply(MapInput.spaceship().merge(MapInput.small_room_shape()), def)

# 	room.set_room_def(def)
# 	room.setup_tileset()
# 	room.fill_tilemap_borders()
# 	room.tilemap.force_update()

# 	var tmap_cells = room.tilemap.get_used_cells(0)
# 	assert_array(tmap_cells).is_not_empty()

# 	room.add_tile_chunks({count=1})
# 	var new_tmap_cells = room.tilemap.get_used_cells(0)
# 	assert_int(len(new_tmap_cells) - len(tmap_cells)).is_equal(1) # added one tile
# 	# TODO assert the new tile's position

## add entities ################################################

func test_build_room_adds_entities():
	var ent_defs = GridParser.parse({contents="""
name Entity Chunks

==============
LEGEND
==============

x = Tile
p = Player

==============
ENTITIES
==============

name Player Start

.p.
xxx
	"""})

	var room = auto_free(VaniaRoom.new())
	var def = VaniaRoomDef.new({entity_defs=ent_defs})
	MapInput.apply(MapInput.spaceship()\
		.merge(MapInput.has_player())\
		.merge(MapInput.small_room_shape()), def)

	room.set_room_def(def)
	room.ensure_children()
	room.setup_tileset()
	room.fill_tilemap_borders()
	room.tilemap.force_update()
	var tmap_cells = room.tilemap.get_used_cells(0)
	assert_array(tmap_cells).is_not_empty()

	var og_count = room.get_child_count()

	room.add_entities()

	var new_count = room.get_child_count()
	assert_that(new_count - og_count).is_equal(1) # new entity added as child
