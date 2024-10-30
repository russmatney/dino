class_name BrickLevelGenTests
extends GdUnitTestSuite

func free_data(data):
	var nodes = []
	nodes.append_array(data.entities)
	nodes.append_array(data.tilemaps)
	nodes.append_array(data.rooms)
	for node in nodes:
		node.queue_free()

## Tilemaps ####################################################################

func test_generate_tilemap_combination():
	var data = BrickLevelGen.generate_level({contents="name Rooms

=======
LEGEND
=======

p = Player
x = Tile

=======
ROOMS
=======

room one

xpx", room_count=3, seed=1,})
	assert_that(len(data.tilemaps)).is_equal(1)
	var combined_tilemap = data.tilemaps[0]
	assert_that(combined_tilemap.get_used_cells()).contains_exactly_in_any_order([
		Vector2i(0,0),
		Vector2i(2,0),
		Vector2i(3,0),
		Vector2i(5,0),
		Vector2i(6,0),
		Vector2i(8,0),
		])

	free_data(data)

func test_generate_tilemap_with_borders():
	var data = BrickLevelGen.generate_level({contents="name Rooms

=======
LEGEND
=======

p = Player
x = Tile

=======
ROOMS
=======

room one

xpx", room_count=2, seed=1, label_to_tilemap={"Tile": {add_borders=true}}})
	assert_that(len(data.tilemaps)).is_equal(1)
	var combined_tilemap = data.tilemaps[0]
	assert_that(combined_tilemap.get_used_cells()).contains_exactly_in_any_order([
		Vector2i(-1,0), Vector2i(-1,1), Vector2i(-1,-1),
		Vector2i(0,0), Vector2i(0,1), Vector2i(0,-1),
		Vector2i(1,1), Vector2i(1,-1),
		Vector2i(2,0), Vector2i(2,1), Vector2i(2,-1),
		Vector2i(3,0), Vector2i(3,1), Vector2i(3,-1),
		Vector2i(4,1), Vector2i(4,-1),
		Vector2i(5,0), Vector2i(5,1), Vector2i(5,-1),
		Vector2i(6,0), Vector2i(6,1), Vector2i(6,-1),
		])

	free_data(data)

func test_generate_multiple_tilemaps():
	var data = BrickLevelGen.generate_level({contents="name Rooms

=======
LEGEND
=======

x = Tile
t = Pit

=======
ROOMS
=======

name one

xtx", seed=1, room_count=2, label_to_tilemap={"Tile": {}, "Pit": {}}})
	assert_that(len(data.tilemaps)).is_equal(2)
	var tile = data.tilemaps[0]
	assert_that(tile.get_used_cells()).contains_exactly_in_any_order([
		Vector2i(0,0),
		Vector2i(2,0),
		Vector2i(3,0),
		Vector2i(5,0),
		])
	var pit = data.tilemaps[1]
	assert_that(pit.get_used_cells()).contains_exactly_in_any_order([
		Vector2i(1,0),
		Vector2i(4,0),
		])

	free_data(data)


## Entities ####################################################################

func test_generate_entities():
	var data = BrickLevelGen.generate_level({contents="name Rooms

=======
LEGEND
=======

p = Player
x = Tile

=======
ROOMS
=======

room one

xpx", room_count=1, seed=1, label_to_entity={"Player": {}}})

	assert_that(len(data.entities)).is_equal(1)
	var p = data.entities[0]
	assert_that(p.scene_file_path).is_equal("res://src/dino/entities/PlayerSpawnPoint.tscn")
	assert_that(p.position).is_equal(Vector2(1,0) * 16)

	free_data(data)
