extends GutTest

## gen_room_def ##################################################################

func test_gen_room_def_basic():
	var room = PluggsRoom.gen_room_def({
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

	assert_eq(room.name, "Test Room")
	assert_eq(room.shape, [
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

	var room = PluggsRoom.gen_room_def({
		contents=contents,
		filter_rooms=func(room): return room.get("funky")})

	assert_eq(room.name, "Funky Test Room")
	assert_eq(room.shape, [
		[null, null, null],
		[null, null, null],
		[["Tile"], null, null]
		])

	var room_2 = PluggsRoom.gen_room_def({
		contents=contents,
		filter_rooms=func(room): return not room.get("funky")})

	assert_eq(room_2.name, "Test Room")
	assert_eq(room_2.shape, [
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

xxx
xp.
x..
"


func test_create_room_basic():
	var room = PluggsRoom.create_room({contents=pluggs_room_contents})
	assert_eq(room.name, "Test Room")
	assert_eq(room.position, Vector2.ZERO)
	room.free()

func test_create_room_based_on_last_room():
	var room = PluggsRoom.create_room({contents=pluggs_room_contents})
	var another_room = PluggsRoom.create_room({contents=pluggs_room_contents}, room)
	assert_eq(another_room.name, "Test Room")
	assert_eq(another_room.position, Vector2(48,0)) # 3 x 16 = 48
	room.free()
	another_room.free()

func test_create_room_color_rect():
	var room = PluggsRoom.create_room({contents=pluggs_room_contents})
	assert_eq(room.name, "Test Room")
	assert_eq(room.position, Vector2.ZERO)
	assert_eq(room.rect.size, Vector2(48, 48))
	room.free()
