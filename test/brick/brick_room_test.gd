class_name BrickRoomTest
extends GdUnitTestSuite

## gen_room_def ##################################################################

func test_gen_room_def_basic():
	var room = PluggsRoom.gen_room_def(null, {
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

## count_to_floor_tile helper ##################################################################

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

## adjacent 'door' alignment ##################################################################

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

## adjacent 'door' alignment, open ceiling ##################################################

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

## adjacent 'door' alignment, added above last room ######################################

func create_rooms(room_opts):
	var last_room
	var rooms = []
	for i in len(room_opts):
		var opts = room_opts[i]
		if last_room != null:
			opts.last_room = last_room
		last_room = auto_free(BrickRoom.create_room(room_opts[i]))
		rooms.append(last_room)
	return rooms


var next_room_3 = "test Room Defs

=======
LEGEND
=======

p = Player
x = Tile

=======
ROOMS
=======

name Start Room
start

x.x
xp.
xxx

name End Room
end

xxx
..x
xxx

name Corner
from_below

xxx
x..
x.x
"

func test_next_room_position_added_to_top():
	var rooms = create_rooms([
		{contents=next_room_3, flags=["start"]},
		{contents=next_room_3, flags=["from_below"], side=Vector2.UP},
		{contents=next_room_3, flags=["end"], side=Vector2.RIGHT},
		])
	var room_1 = rooms[0]
	var room_2 = rooms[1]
	var room_3 = rooms[2]
	assert_that(room_1.name).is_equal("Start Room")
	assert_that(room_2.name).is_equal("Corner")
	assert_that(room_2.position).is_equal(Vector2(0, 3) * 16)
	assert_that(room_3.position).is_equal(Vector2(3, 3) * 16)
