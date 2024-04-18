extends GdUnitTestSuite

func before():
	Log.set_colors_termsafe()

## GridParser.parse() #####################################################

func test_parse_returns_room_defs():
	var res = GridParser.parse({contents="
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
	assert_that(res.name).is_equal("PuzzRooms")
	assert_that(res.prelude.name).is_equal("PuzzRooms")
	assert_that(res.prelude).is_equal({name="PuzzRooms"})
	assert_that(res.legend).is_equal({".": ["Empty"], "p": ["Player"], "x": ["Tile"]})
	assert_that(len(res.grids)).is_equal(1)
	assert_that(res.grids[0].meta.room_type).is_equal("SQUARE")
	assert_that(res.grids[0].meta.is_start).is_true()
	assert_that(res.grids[0].shape).is_equal([
		[["Tile"], ["Tile"], ["Tile"]],
		[["Tile"], ["Player"], ["Empty"]],
		[["Tile"], ["Empty"], ["Empty"]]
		])

func test_parse_returns_room_defs_without_empty():
	var res = GridParser.parse({contents="
name PuzzRooms

=======
LEGEND
=======

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
	assert_that(res.name).is_equal("PuzzRooms")
	assert_that(res.prelude.name).is_equal("PuzzRooms")
	assert_that(res.prelude).is_equal({name="PuzzRooms"})
	assert_that(res.legend).is_equal({"p": ["Player"], "x": ["Tile"]})
	assert_that(len(res.grids)).is_equal(1)
	assert_that(res.grids[0].meta.room_type).is_equal("SQUARE")
	assert_that(res.grids[0].meta.is_start).is_true()
	assert_that(res.grids[0].shape).is_equal([
		[["Tile"], ["Tile"], ["Tile"]],
		[["Tile"], ["Player"], null],
		[["Tile"], null, null]
		])

## GridParser.parse_raw() #####################################################

func test_prelude():
	var parsed = GridParser.parse_raw("name PuzzRooms")

	assert_that(parsed).contains_keys(["prelude"])
	assert_that(parsed.prelude.name).is_equal("PuzzRooms")

func test_legend():
	var parsed = GridParser.parse_raw("name PuzzRooms

=======
LEGEND
=======

. = Empty
p = Player and Tile
x = Tile
")

	assert_that(parsed).contains_keys(["legend"])
	assert_that(parsed.legend["."]).is_equal(["Empty"])
	assert_that(parsed.legend["p"]).is_equal(["Player", "Tile"])
	assert_that(parsed.legend["x"]).is_equal(["Tile"])

func test_parse_legend_and():
	var parsed = GridParser.parse({contents="name PuzzRooms

=======
LEGEND
=======

p = Player and Tile
x = Tile

=======
ROOMS
=======

room 1

xpx
"})
	assert_that(parsed.grids[0].shape).is_equal([
		[["Tile"], ["Player", "Tile"], ["Tile"],]
		])


func test_rooms():
	var parsed = GridParser.parse_raw("name PuzzRooms

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
		["x", "x", "x"],
		["x", "p", "."],
		["x", ".", "."]
		])
	assert_that(parsed.rooms[1].shape).is_equal([
		["x", "x", "x", "x", "x", "x"],
		["x", ".", ".", ".", "p", "."],
		["x", ".", ".", ".", ".", "."],
		])


func test_trailing_empty_lines():
	var parsed = GridParser.parse_raw("name PuzzRooms

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
	assert_that(parsed.rooms[0].room_name).is_equal("A")
	assert_that(parsed.rooms[1].room_name).is_equal("B")

	assert_that(parsed.rooms[0].shape).is_equal([
		["x", "x", "x"],
		["x", ".", "."],
		["x", ".", "."]
		])
	assert_that(parsed.rooms[1].shape).is_equal([
		["x", "x", "x", "x", "x", "x"],
		["x", ".", ".", ".", ".", "."],
		["x", ".", ".", ".", ".", "."],
		])


func test_trailing_spaces_or_tabs():
	var parsed = GridParser.parse_raw("name PuzzRooms

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
	")

	assert_that(parsed).contains_keys(["rooms"])
	assert_that(len(parsed.rooms)).is_equal(1)
	assert_that(parsed.rooms[0].room_name).is_equal("A")
	assert_that(parsed.rooms[0].shape).is_equal([
		["x", "x", "x"],
		["x", ".", "."],
		["x", ".", "."]
		])


func test_sanity_grid_parsing():
	var parsed = GridParser.parse({
		contents="name PuzzRooms

=======
LEGEND
=======

x = Tile

=======
ROOMS
=======

room_name A

.x.
	"})

	assert_that(len(parsed.grids)).is_equal(1)
	assert_that(parsed.grids[0].shape).is_equal([
		[null, ["Tile"], null],
		])
	var shape_dict = parsed.grids[0].get_shape_dict()
	assert_that(shape_dict).is_equal({
		Vector2i(0, 0): null,
		Vector2i(1, 0): ["Tile"],
		Vector2i(2, 0): null,
		})

func test_label_missing_from_legend():
	var parsed = GridParser.parse({
		contents="name PuzzRooms

=======
LEGEND
=======

z = Zile

=======
ROOMS
=======

room_name A

.x.
	"})

	assert_that(len(parsed.grids)).is_equal(1)
	assert_that(parsed.grids[0].shape).is_equal([
		[null, ["x"], null],
		])

	var shape_dict = parsed.grids[0].get_shape_dict()
	assert_that(shape_dict).is_equal({
		Vector2i(0, 0): null,
		Vector2i(1, 0): ["x"],
		Vector2i(2, 0): null,
		})
