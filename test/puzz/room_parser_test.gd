extends GutTest


func test_prelude():
	var parsed = RoomParser.parse("title PuzzRooms")

	assert_has(parsed, "prelude", "prelude not parsed")
	assert_eq(parsed.prelude.title, "PuzzRooms")

func test_legend():
	var parsed = RoomParser.parse("title PuzzRooms

=======
LEGEND
=======

. = Empty
p = Player
x = Tile
")

	assert_has(parsed, "legend", "legend not parsed")
	assert_eq(parsed.legend["."], ["Empty"])
	assert_eq(parsed.legend["p"], ["Player"])
	assert_eq(parsed.legend["x"], ["Tile"])


func test_rooms():
	var parsed = RoomParser.parse("title PuzzRooms

=======
LEGEND
=======

. = Empty
p = Player
x = Tile

=======
ROOMS
=======

room_type SQUARE
is_start

xxx
xp.
x..

room_type LONG

xxxxxx
x...p.
x.....
")

	assert_has(parsed, "rooms", "rooms not parsed")
	assert_eq(len(parsed.rooms), 2)

	# arbitrary metadata
	assert_eq(parsed.rooms[0].room_type, "SQUARE")
	assert_eq(parsed.rooms[1].room_type, "LONG")
	assert_eq(parsed.rooms[0].is_start, true)

	# shape
	assert_eq(parsed.rooms[0].shape, [
		[["Tile"], ["Tile"], ["Tile"]],
		[["Tile"], ["Player"], null],
		[["Tile"], null, null]
		])
	assert_eq(parsed.rooms[1].shape, [
		[["Tile"], ["Tile"], ["Tile"], ["Tile"], ["Tile"], ["Tile"]],
		[["Tile"], null, null, null, ["Player"], null],
		[["Tile"], null, null, null, null, null],
		])


func test_trailing_empty_lines():
	var parsed = RoomParser.parse("title PuzzRooms

=======
LEGEND
=======

. = Empty
x = Tile

=======
ROOMS
=======

room_name A

xxx
x..
x..

room_name B

xxxxxx
x.....
x.....


")

	assert_has(parsed, "rooms", "rooms not parsed")
	assert_eq(len(parsed.rooms), 2)

	# arbitrary metadata
	assert_eq(parsed.rooms[0].room_name, "A")
	assert_eq(parsed.rooms[1].room_name, "B")

	# shape
	assert_eq(parsed.rooms[0].shape, [
		[["Tile"], ["Tile"], ["Tile"]],
		[["Tile"], null, null],
		[["Tile"], null, null]
		])
	assert_eq(parsed.rooms[1].shape, [
		[["Tile"], ["Tile"], ["Tile"], ["Tile"], ["Tile"], ["Tile"]],
		[["Tile"], null, null, null, null, null],
		[["Tile"], null, null, null, null, null],
		])
