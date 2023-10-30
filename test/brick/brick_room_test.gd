class_name BrickRoomTest
extends GdUnitTestSuite

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
	assert_that(room_2.position).is_equal(Vector2(0, -3) * 16)
	assert_that(room_3.position).is_equal(Vector2(3, -3) * 16)


## doors on any side ######################################

var next_room_4 = "test Room Defs

=======
LEGEND
=======

x = Tile

=======
ROOMS
=======

name Right
open_right

x..
xxx
xxx

name Left
open_left

xxx
..x
xxx

name Top
open_top

x.x
x.x
xxx

name Bottom
open_bottom

xxx
x.x
x.x
"

func test_create_rooms_going_right():
	var rooms = create_rooms([
		{contents=next_room_4, flags=["open_right"]},
		{contents=next_room_4, flags=["open_left"], side=Vector2.RIGHT},
		])
	var room_1 = rooms[0]
	var room_2 = rooms[1]
	assert_that(room_1.name).is_equal("Right")
	assert_that(room_2.name).is_equal("Left")
	assert_that(room_2.position).is_equal(Vector2(3, -1) * 16)

func test_create_rooms_going_left():
	var rooms = create_rooms([
		{contents=next_room_4, flags=["open_left"]},
		{contents=next_room_4, flags=["open_right"], side=Vector2.LEFT},
		])
	var room_1 = rooms[0]
	var room_2 = rooms[1]
	assert_that(room_1.name).is_equal("Left")
	assert_that(room_2.name).is_equal("Right")
	assert_that(room_2.position).is_equal(Vector2(-3, 1) * 16)

func test_create_rooms_going_down():
	var rooms = create_rooms([
		{contents=next_room_4, flags=["open_bottom"]},
		{contents=next_room_4, flags=["open_top"], side=Vector2.DOWN},
		])
	var room_1 = rooms[0]
	var room_2 = rooms[1]
	assert_that(room_1.name).is_equal("Bottom")
	assert_that(room_2.name).is_equal("Top")
	assert_that(room_2.position).is_equal(Vector2(0, 3) * 16)

func test_create_rooms_going_up():
	var rooms = create_rooms([
		{contents=next_room_4, flags=["open_top"]},
		{contents=next_room_4, flags=["open_bottom"], side=Vector2.UP},
		])
	var room_1 = rooms[0]
	var room_2 = rooms[1]
	assert_that(room_1.name).is_equal("Top")
	assert_that(room_2.name).is_equal("Bottom")
	assert_that(room_2.position).is_equal(Vector2(0, -3) * 16)

## discovered issues/use-cases #########

var shirt_room_defs_alignment = "name Shirt Room Defs

==============
LEGEND
==============

x = Tile

==============
ROOMS
==============

name Start
first

xxxxxxx
x......
x..p...
x......
x......
xxxxxxx

name Walker

xxx..xx
xxx..xx
xx...xx
.......
....w..
xx...xx
xx...xx
"

func test_create_rooms_align_shirt_walker_fix():
	var rooms = create_rooms([
		{contents=shirt_room_defs_alignment, flags=["first"]},
		{contents=shirt_room_defs_alignment, skip_flags=["first"], side=Vector2.RIGHT},
		])
	var room_1 = rooms[0]
	var room_2 = rooms[1]
	assert_that(room_1.name).is_equal("Start")
	assert_that(room_2.name).is_equal("Walker")

	"
	y-offset should end up as zero!
	xxxxxxx xxx..xx
	x......	xxx..xx
	x..p...	xx...xx
	x......	.......
	x......	....w..
	xxxxxxx	xx...xx
			xx...xx
	"

	assert_that(room_1.position).is_equal(Vector2(0, 0))
	assert_that(room_2.position).is_equal(Vector2(7, 0) * 16)
