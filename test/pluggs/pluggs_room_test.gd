class_name PluggsRoomTest
extends GdUnitTestSuite

## gen_room_def ##################################################################

func test_gen_room_def_basic():
	var room = PluggsRoom.gen_room_def(null, {
		contents="title PluggsRoomsTest

=======
LEGEND
=======

. = Empty
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

func test_gen_room_def_filter():
	var contents = "title PluggsRoomsTest

=======
LEGEND
=======

. = Empty
p = Player
x = Tile

=======
ROOMS
=======

name Test Room

xxx
xp.
x..

name Funky Test Room
funky

...
...
x..
"

	var room = PluggsRoom.gen_room_def(null, {
		contents=contents,
		filter_rooms=func(room): return room.has_flag("funky")})

	assert_that(room.name).is_equal("Funky Test Room")
	assert_that(room.shape).is_equal([
		[null, null, null],
		[null, null, null],
		[["Tile"], null, null]
		])

	var room_2 = PluggsRoom.gen_room_def(null, {
		contents=contents,
		filter_rooms=func(room): return not room.has_flag("funky")})

	assert_that(room_2.name).is_equal("Test Room")
	assert_that(room_2.shape).is_equal([
		[["Tile"], ["Tile"], ["Tile"]],
		[["Tile"], ["Player"], null],
		[["Tile"], null, null]
		])

## create_room ##################################################################

var pluggs_room_contents = "test Pluggs Room Defs

=======
LEGEND
=======

. = Empty
p = Player
x = Tile

=======
ROOMS
=======

name Test Room

...
xp.
xxx
"

func test_create_room_basic():
	var room = PluggsRoom.create_room({contents=pluggs_room_contents})
	assert_that(room.name).is_equal("Test Room")
	assert_that(room.position).is_equal(Vector2.ZERO)
	room.free()

func test_create_room_based_on_last_room():
	var room = PluggsRoom.create_room({contents=pluggs_room_contents})
	var another_room = PluggsRoom.create_room({contents=pluggs_room_contents, last_room=room})
	assert_that(another_room.name).is_equal("Test Room")
	# y is 16 b/c of the align-floor logic - moves down to smoothly transition between rooms
	assert_that(another_room.position).is_equal(Vector2(48,16)) # 3 x 16 = 48
	room.free()
	another_room.free()

func test_create_room_color_rect():
	var room = PluggsRoom.create_room({contents=pluggs_room_contents})
	assert_that(room.name).is_equal("Test Room")
	assert_that(room.position).is_equal(Vector2.ZERO)
	assert_that(room.rect.size).is_equal(Vector2(48,48))
	room.free()

func test_create_room_tilemap():
	var room = PluggsRoom.create_room({contents=pluggs_room_contents})
	assert_that(room.name).is_equal("Test Room")
	assert_that(room.position).is_equal(Vector2.ZERO)
	assert_that(room.tilemap.get_used_cells(0)).contains_exactly_in_any_order([
		Vector2i(0,1),
		Vector2i(0,2),
		Vector2i(1,2),
		Vector2i(2,2),
		])
	room.free()
