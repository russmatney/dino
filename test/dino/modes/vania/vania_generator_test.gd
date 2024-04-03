extends GdUnitTestSuite
class_name VaniaGeneratorTest

func test_build_room_sets_tilemap_borders():
	var room = VaniaRoom.new()
	var def = VaniaRoomDef.new()
	# set a tileset and small room
	RoomInputs.spaceship().merge(RoomInputs.small_room()).update_def(def)

	room.set_room_def(def)
	room.setup_tileset()
	room.fill_tilemap_borders()
	room.tilemap.force_update()

	var tmap_cells = room.tilemap.get_used_cells(0)
	assert_array(tmap_cells).is_not_empty()
	assert_array(tmap_cells).contains([Vector2i(), Vector2i(0, 1), Vector2i(1,0)])
	# TODO assert on each corner

func test_build_room_adds_tile_chunks():
	var tile_defs = GridParser.parse({contents="""
name Tile Chunks

==============
LEGEND
==============

x = Tile
n = NewTile

==============
CHUNKS
==============

name Tile
tile_chunk

xxx
xn.
x..
	"""})

	var room = VaniaRoom.new()
	var def = VaniaRoomDef.new({tile_defs=tile_defs})
	RoomInputs.spaceship().merge(RoomInputs.small_room()).update_def(def)

	room.set_room_def(def)
	room.setup_tileset()
	room.fill_tilemap_borders()
	room.tilemap.force_update()

	var tmap_cells = room.tilemap.get_used_cells(0)
	assert_array(tmap_cells).is_not_empty()

	room.add_tile_chunks({count=1})
	var new_tmap_cells = room.tilemap.get_used_cells(0)
	assert_int(len(new_tmap_cells) - len(tmap_cells)).is_equal(1) # added one tile
	# TODO assert the new tile's position

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

	var room = VaniaRoom.new()
	var def = VaniaRoomDef.new({entity_defs=ent_defs})
	RoomInputs.player_room().merge(RoomInputs.spaceship()).update_def(def)

	room.set_room_def(def)
	room.setup_tileset()
	room.fill_tilemap_borders()
	room.tilemap.force_update()
	var tmap_cells = room.tilemap.get_used_cells(0)
	assert_array(tmap_cells).is_not_empty()

	var og_count = room.get_child_count()

	room.add_entities()

	var new_count = room.get_child_count()
	assert_that(new_count - og_count).is_equal(1) # new entity added as child
	# TODO assert that label_to_entity setup is called
