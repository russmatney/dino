class_name WoodsRoomTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

## data ###########################################################

var room_defs_txt = "title WoodsRooms

=======
LEGEND
=======

p = Player
x = Tile

=======
ROOMS
=======

room_type START

xxx
xp.
xxx

room_type END

xxx
..x
xxx

room_type SQUARE

xxx
.p.
xxx

room_type LONG

xxxxxx
......
xxxxxx

room_type FALL

xxx
..x
x.x
x.x
x..
xxx

room_type CLIMB

xxx
x..
x.x
x.x
..x
xxx
"

## create_room ###########################################################

func has_type(typ):
	return func(r):
		return typ == r.meta.get("room_type")

func test_create_room_start():
	var room = BrickRoom.create_room({
		contents=room_defs_txt,
		filter_rooms=has_type("START"),
		})

	assert_that(room.position).is_equal(Vector2.ZERO)
	assert_that(room.def.meta.room_type).is_equal("START")
	assert_that(room.tilemaps.values()[0].get_used_cells(0)).contains_exactly_in_any_order([
		Vector2i(0, 2),
		Vector2i(0, 1),
		Vector2i(0, 0),
		Vector2i(1, 0),
		Vector2i(1, 2),
		Vector2i(2, 0),
		Vector2i(2, 2),
		])
	room.free()

func test_create_room_end():
	var room = BrickRoom.create_room({
		contents=room_defs_txt,
		filter_rooms=has_type("END"),
		})

	assert_that(room.position).is_equal(Vector2.ZERO)
	assert_that(room.def.meta.room_type).is_equal("END")
	assert_that(room.tilemaps.values()[0].get_used_cells(0)).contains_exactly_in_any_order([
		Vector2i(0, 2),
		Vector2i(0, 0),
		Vector2i(1, 0),
		Vector2i(1, 2),
		Vector2i(2, 0),
		Vector2i(2, 1),
		Vector2i(2, 2),
		])
	room.free()

func test_create_room_square():
	var room = BrickRoom.create_room({
		contents=room_defs_txt,
		filter_rooms=has_type("SQUARE"),
		})

	assert_that(room.position).is_equal(Vector2.ZERO)
	assert_that(room.def.meta.room_type).is_equal("SQUARE")
	assert_that(room.tilemaps.values()[0].get_used_cells(0)).contains_exactly_in_any_order([
		Vector2i(0, 2),
		Vector2i(1, 2),
		Vector2i(2, 2),
		Vector2i(2, 0),
		Vector2i(1, 0),
		Vector2i(0, 0),
		])
	room.free()

func test_create_room_long():
	var room = BrickRoom.create_room({
		contents=room_defs_txt,
		filter_rooms=has_type("LONG"),
		})

	assert_that(room.position).is_equal(Vector2.ZERO)
	assert_that(room.def.meta.room_type).is_equal("LONG")
	assert_that(room.tilemaps.values()[0].get_used_cells(0)).contains_exactly_in_any_order([
		Vector2i(0, 0),
		Vector2i(1, 0),
		Vector2i(2, 0),
		Vector2i(3, 0),
		Vector2i(4, 0),
		Vector2i(5, 0),
		Vector2i(0, 2),
		Vector2i(1, 2),
		Vector2i(2, 2),
		Vector2i(3, 2),
		Vector2i(4, 2),
		Vector2i(5, 2),
		])
	room.free()

## create_room based on last room ###########################################################

func test_create_room_after_start_or_square():
	var dim = 16
	var tests = [
		{filter_rooms=has_type("SQUARE"), expected={
			size=Vector2(dim, dim),
			position=Vector2(dim, 0)}},
		{filter_rooms=has_type("LONG"), expected={
			size=Vector2(dim*2, dim),
			position=Vector2(dim, 0)}},
		{filter_rooms=has_type("CLIMB"), expected={
			size=Vector2(dim, dim*2),
			position=Vector2(dim, -1*dim)}},
		{filter_rooms=has_type("FALL"), expected={
			size=Vector2(dim, dim*2),
			position=Vector2(dim, 0)}}
		]
	var start_room = BrickRoom.create_room({
		filter_rooms=has_type("START"),
		contents=room_defs_txt,
		})

	var square_room = BrickRoom.create_room({
		filter_rooms=has_type("SQUARE"),
		contents=room_defs_txt,
		})

	assert_that(len(tests)).is_greater(0)
	for test in tests:
		var room = BrickRoom.create_room({filter_rooms=test.filter_rooms,
			contents=room_defs_txt,
			last_room=start_room})
		assert_that(room.rect.size).is_equal(test.expected.size * 3)
		assert_that(room.position).is_equal(test.expected.position * 3)

		var room_sq = BrickRoom.create_room({filter_rooms=test.filter_rooms,
			contents=room_defs_txt,
			last_room=square_room})
		assert_that(room_sq.rect.size).is_equal(test.expected.size * 3)
		assert_that(room_sq.position).is_equal(test.expected.position * 3)
		room.free()
		room_sq.free()
	start_room.free()
	square_room.free()

func test_create_room_after_long():
	var dim = 16
	var tests = [
		{filter_rooms=has_type("SQUARE"), expected={
			size=Vector2(dim, dim),
			position=Vector2(dim*2, 0)}},
		{filter_rooms=has_type("LONG"), expected={
			size=Vector2(dim*2, dim),
			position=Vector2(dim*2, 0)}},
		{filter_rooms=has_type("CLIMB"), expected={
			size=Vector2(dim, dim*2),
			position=Vector2(dim*2, -1*dim)}},
		{filter_rooms=has_type("FALL"), expected={
			size=Vector2(dim, dim*2),
			position=Vector2(dim*2, 0)}}
		]
	var long_room = BrickRoom.create_room({
		filter_rooms=has_type("LONG"),
		contents=room_defs_txt,
		})

	assert_that(len(tests)).is_greater(0)
	for test in tests:
		var room = BrickRoom.create_room({filter_rooms=test.filter_rooms,
			contents=room_defs_txt,
			last_room=long_room})
		assert_that(room.rect.size).is_equal(test.expected.size * 3)
		assert_that(room.position).is_equal(test.expected.position * 3)
		room.free()
	long_room.free()

func test_create_room_after_fall():
	var dim = 16
	var tests = [
		{filter_rooms=has_type("SQUARE"), expected={
			size=Vector2(dim, dim),
			position=Vector2(dim, dim)}},
		{filter_rooms=has_type("LONG"), expected={
			size=Vector2(dim*2, dim),
			position=Vector2(dim, dim)}},
		{filter_rooms=has_type("CLIMB"), expected={
			size=Vector2(dim, dim*2),
			position=Vector2(dim, 0)}},
		{filter_rooms=has_type("FALL"), expected={
			size=Vector2(dim, dim*2),
			position=Vector2(dim, dim)}}
		]
	var fall_room = BrickRoom.create_room({filter_rooms=has_type("FALL"), contents=room_defs_txt,})

	assert_that(len(tests)).is_greater(0)
	for test in tests:
		var room = BrickRoom.create_room({filter_rooms=test.filter_rooms,
			contents=room_defs_txt,
			last_room=fall_room})
		assert_that(room.rect.size).is_equal(test.expected.size * 3)
		assert_that(room.position).is_equal(test.expected.position * 3)
		room.free()
	fall_room.free()

func test_create_room_after_climb():
	var dim = 16
	var tests = [
		{filter_rooms=has_type("SQUARE"), expected={
			size=Vector2(dim, dim),
			position=Vector2(dim, 0)}},
		{filter_rooms=has_type("LONG"), expected={
			size=Vector2(dim*2, dim),
			position=Vector2(dim, 0)}},
		{filter_rooms=has_type("CLIMB"), expected={
			size=Vector2(dim, dim*2),
			position=Vector2(dim, -1*dim)}},
		{filter_rooms=has_type("FALL"), expected={
			size=Vector2(dim, dim*2),
			position=Vector2(dim, 0)}}
		]
	var climb_room = BrickRoom.create_room({filter_rooms=has_type("CLIMB"), contents=room_defs_txt,})

	assert_that(len(tests)).is_greater(0)
	for test in tests:
		var room = BrickRoom.create_room({filter_rooms=test.filter_rooms,
			contents=room_defs_txt, last_room=climb_room})
		assert_that(room.rect.size).is_equal(test.expected.size * 3)
		assert_that(room.position).is_equal(test.expected.position * 3)
		room.free()
	climb_room.free()
