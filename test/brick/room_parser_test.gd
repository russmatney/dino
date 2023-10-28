extends GdUnitTestSuite

## RoomParser.parse() #####################################################

func test_parse_returns_room_defs():
	var res = RoomParser.parse({contents="
name PuzzRooms

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
x.."})

	Debug.pr("parsed", res)

	assert_that(res.name).is_equal("PuzzRooms")
	assert_that(res.prelude.name).is_equal("PuzzRooms")
	assert_that(res.prelude).is_equal({name="PuzzRooms"})
	assert_that(res.legend).is_equal({".": ["Empty"], "p": ["Player"], "x": ["Tile"]})
	assert_that(len(res.rooms)).is_equal(1)
	assert_that(res.rooms[0].meta.room_type).is_equal("SQUARE")
	assert_that(res.rooms[0].meta.is_start).is_true()
	assert_that(res.rooms[0].shape).is_equal([
		[["Tile"], ["Tile"], ["Tile"]],
		[["Tile"], ["Player"], null],
		[["Tile"], null, null]
		])

## RoomParser.parse_raw() #####################################################

func test_prelude():
	var parsed = RoomParser.parse_raw("name PuzzRooms")

	assert_that(parsed).contains_keys(["prelude"])
	assert_that(parsed.prelude.name).is_equal("PuzzRooms")

func test_legend():
	var parsed = RoomParser.parse_raw("name PuzzRooms

=======
LEGEND
=======

. = Empty
p = Player
x = Tile
")

	assert_that(parsed).contains_keys(["legend"])
	assert_that(parsed.legend["."]).is_equal(["Empty"])
	assert_that(parsed.legend["p"]).is_equal(["Player"])
	assert_that(parsed.legend["x"]).is_equal(["Tile"])


func test_rooms():
	var parsed = RoomParser.parse_raw("name PuzzRooms

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

	assert_that(parsed).contains_keys(["rooms"])
	assert_that(len(parsed.rooms)).is_equal(2)

	# arbitrary metadata
	assert_that(parsed.rooms[0].room_type).is_equal("SQUARE")
	assert_that(parsed.rooms[1].room_type).is_equal("LONG")
	assert_that(parsed.rooms[0].is_start).is_equal(true)

	# shape
	assert_that(parsed.rooms[0].shape).is_equal([
		[["Tile"], ["Tile"], ["Tile"]],
		[["Tile"], ["Player"], null],
		[["Tile"], null, null]
		])
	assert_that(parsed.rooms[1].shape).is_equal([
		[["Tile"], ["Tile"], ["Tile"], ["Tile"], ["Tile"], ["Tile"]],
		[["Tile"], null, null, null, ["Player"], null],
		[["Tile"], null, null, null, null, null],
		])


func test_trailing_empty_lines():
	var parsed = RoomParser.parse_raw("name PuzzRooms

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

	assert_that(parsed).contains_keys(["rooms"])
	assert_that(len(parsed.rooms)).is_equal(2)

	# arbitrary metadata
	assert_that(parsed.rooms[0].room_name).is_equal("A")
	assert_that(parsed.rooms[1].room_name).is_equal("B")

	# shape
	assert_that(parsed.rooms[0].shape).is_equal([
		[["Tile"], ["Tile"], ["Tile"]],
		[["Tile"], null, null],
		[["Tile"], null, null]
		])
	assert_that(parsed.rooms[1].shape).is_equal([
		[["Tile"], ["Tile"], ["Tile"], ["Tile"], ["Tile"], ["Tile"]],
		[["Tile"], null, null, null, null, null],
		[["Tile"], null, null, null, null, null],
		])
