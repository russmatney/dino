extends GutTest


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

name Disabled Test Room
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
