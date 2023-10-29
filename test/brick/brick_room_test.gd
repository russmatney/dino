class_name BrickRoomTest
extends GdUnitTestSuite

## gen_room_def ##################################################################

func test_gen_room_def_basic():
	var room = PluggsRoom.gen_room_def({
		contents="title BrickRoomTest

=======
LEGEND
=======

p = Player
x = Tile

=======
ROOMS
=======

name Test Room

xxx
xp.
x..
"})

	assert_that(room.name).is_equal("Test Room")
	assert_that(room.shape).is_equal([
		[["Tile"], ["Tile"], ["Tile"]],
		[["Tile"], ["Player"], null],
		[["Tile"], null, null]
		])

## create_room ##################################################################

func test_create_room_basic():
	var room = BrickRoom.create_room({contents="name Room Defs

=======
LEGEND
=======

p = Player
x = Tile

=======
ROOMS
=======

name Test Room

...
xp.
xxx
"})
	assert_that(room.name).is_equal("Test Room")
	assert_that(room.position).is_equal(Vector2.ZERO)
	room.free()

## room_positioning ##################################################################

func test_count_to_floor_tile():
	var res = BrickRoom.count_to_floor_tile([null, ["Tile"], null])
	assert_that(res).is_equal(1)
	res = BrickRoom.count_to_floor_tile([["Tile"], null, ["Tile"], null])
	assert_that(res).is_equal(2)
	res = BrickRoom.count_to_floor_tile([null, null, ["Tile"], null])
	assert_that(res).is_equal(2)
	res = BrickRoom.count_to_floor_tile([["Tile"], null, null, ["Tile"], null])
	assert_that(res).is_equal(3)
	res = BrickRoom.count_to_floor_tile([["Tile"], null, null, ["Tile"], ["Tile"]])
	assert_that(res).is_equal(3)
	res = BrickRoom.count_to_floor_tile([null, null, null, ["Tile"], ["Tile"], null])
	assert_that(res).is_equal(3)

	res = BrickRoom.count_to_floor_tile([["Tile"], ["Tile"], ["Tile"], ["Tile"], ["Tile"], null])
	assert_that(res).is_equal(0)
	res = BrickRoom.count_to_floor_tile([["Tile"], ["Tile"], ["Tile"], ["Tile"], ["Tile"], ["Tile"]])
	assert_that(res).is_equal(0)

var next_room_1 = "test Room Defs

=======
LEGEND
=======

p = Player
x = Tile

=======
ROOMS
=======

name Start Room
first

xxx
xxx
xp.
xxx
xxx
xxx

name End Room
end

xxx
..x
xxx
xxx
"

func test_next_room_position_aligns_empty_tiles():
	var room_1 = BrickRoom.create_room({contents=next_room_1, flags=["first"]})
	assert_that(room_1.name).is_equal("Start Room")

	var room_2 = BrickRoom.create_room({contents=next_room_1, flags=["end"], last_room=room_1})
	assert_that(room_2.name).is_equal("End Room")

	var expected_pos = Vector2(3, 1) * 16 # room 1 width + down one to align empties
	assert_that(room_2.position).is_equal(expected_pos)

	room_1.free()
	room_2.free()

var next_room_2 = "test Room Defs

=======
LEGEND
=======

p = Player
x = Tile

=======
ROOMS
=======

name Start Room
first

...
...
xp.
xxx
xxx
xxx

name End Room
end

...
..x
xxx
xxx
"

func test_next_room_position_aligns_empty_tiles_open_tops():
	var room_1 = BrickRoom.create_room({contents=next_room_2, flags=["first"]})
	assert_that(room_1.name).is_equal("Start Room")

	var room_2 = BrickRoom.create_room({contents=next_room_1, flags=["end"], last_room=room_1})
	assert_that(room_2.name).is_equal("End Room")

	var expected_pos = Vector2(3, 1) * 16 # room 1 width + down one to align empties
	assert_that(room_2.position).is_equal(expected_pos)

	room_1.free()
	room_2.free()
