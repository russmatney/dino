class_name WoodsRoomTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

## data ###########################################################

var room_defs_txt = "title WoodsRooms

=======
LEGEND
=======

. = Empty
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

func test_create_room_no_options():
	var room = WoodsRoom.create_room({contents=room_defs_txt})

	assert_that(room.position).is_equal(Vector2.ZERO)
	assert_that(room.type).is_equal(WoodsRoom.t.SQUARE)
	assert_that(room.def.meta.room_type).is_equal("SQUARE")
	assert_that(room.tilemap.get_used_cells(0)).contains_exactly_in_any_order([
		Vector2i(0, 2),
		Vector2i(1, 2),
		Vector2i(2, 2),
		Vector2i(2, 0),
		Vector2i(1, 0),
		Vector2i(0, 0),
		])
	room.free()

func test_create_room_start():
	var room = WoodsRoom.create_room({
		contents=room_defs_txt,
		type=WoodsRoom.t.START,
		})

	assert_that(room.position).is_equal(Vector2.ZERO)
	assert_that(room.type).is_equal(WoodsRoom.t.START)
	assert_that(room.def.meta.room_type).is_equal("START")
	assert_that(room.tilemap.get_used_cells(0)).contains_exactly_in_any_order([
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
	var room = WoodsRoom.create_room({
		contents=room_defs_txt,
		type=WoodsRoom.t.END,
		})

	assert_that(room.position).is_equal(Vector2.ZERO)
	assert_that(room.type).is_equal(WoodsRoom.t.END)
	assert_that(room.def.meta.room_type).is_equal("END")
	assert_that(room.tilemap.get_used_cells(0)).contains_exactly_in_any_order([
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
	var room = WoodsRoom.create_room({
		contents=room_defs_txt,
		type=WoodsRoom.t.SQUARE,
		})

	assert_that(room.position).is_equal(Vector2.ZERO)
	assert_that(room.type).is_equal(WoodsRoom.t.SQUARE)
	assert_that(room.def.meta.room_type).is_equal("SQUARE")
	assert_that(room.tilemap.get_used_cells(0)).contains_exactly_in_any_order([
		Vector2i(0, 2),
		Vector2i(1, 2),
		Vector2i(2, 2),
		Vector2i(2, 0),
		Vector2i(1, 0),
		Vector2i(0, 0),
		])
	room.free()

func test_create_room_long():
	var room = WoodsRoom.create_room({
		contents=room_defs_txt,
		type=WoodsRoom.t.LONG,
		})

	assert_that(room.position).is_equal(Vector2.ZERO)
	assert_that(room.type).is_equal(WoodsRoom.t.LONG)
	assert_that(room.def.meta.room_type).is_equal("LONG")
	assert_that(room.tilemap.get_used_cells(0)).contains_exactly_in_any_order([
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
		{type=WoodsRoom.t.SQUARE, expected={
			size=Vector2(dim, dim),
			position=Vector2(dim, 0)}},
		{type=WoodsRoom.t.LONG, expected={
			size=Vector2(dim*2, dim),
			position=Vector2(dim, 0)}},
		{type=WoodsRoom.t.CLIMB, expected={
			size=Vector2(dim, dim*2),
			position=Vector2(dim, -1*dim)}},
		{type=WoodsRoom.t.FALL, expected={
			size=Vector2(dim, dim*2),
			position=Vector2(dim, 0)}}
		]
	var start_room = WoodsRoom.create_room({
		type=WoodsRoom.t.START,
		contents=room_defs_txt,
		room_base_dim=dim,
		})

	var square_room = WoodsRoom.create_room({
		type=WoodsRoom.t.SQUARE,
		contents=room_defs_txt,
		room_base_dim=dim,
		})

	assert_that(len(tests)).is_greater(0)
	for test in tests:
		var room = WoodsRoom.create_room({type=test.type, room_base_dim=dim,
			contents=room_defs_txt,
			last_room=start_room})
		assert_that(room.rect.size).is_equal(test.expected.size * 3)
		assert_that(room.position).is_equal(test.expected.position * 3)

		var room_sq = WoodsRoom.create_room({type=test.type, room_base_dim=dim,
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
		{type=WoodsRoom.t.SQUARE, expected={
			size=Vector2(dim, dim),
			position=Vector2(dim*2, 0)}},
		{type=WoodsRoom.t.LONG, expected={
			size=Vector2(dim*2, dim),
			position=Vector2(dim*2, 0)}},
		{type=WoodsRoom.t.CLIMB, expected={
			size=Vector2(dim, dim*2),
			position=Vector2(dim*2, -1*dim)}},
		{type=WoodsRoom.t.FALL, expected={
			size=Vector2(dim, dim*2),
			position=Vector2(dim*2, 0)}}
		]
	var long_room = WoodsRoom.create_room({
		type=WoodsRoom.t.LONG,
		contents=room_defs_txt,
		room_base_dim=dim,
		})

	assert_that(len(tests)).is_greater(0)
	for test in tests:
		var room = WoodsRoom.create_room({type=test.type, room_base_dim=dim,
			contents=room_defs_txt,
			last_room=long_room})
		assert_that(room.rect.size).is_equal(test.expected.size * 3)
		assert_that(room.position).is_equal(test.expected.position * 3)
		room.free()
	long_room.free()

func test_create_room_after_fall():
	var dim = 16
	var tests = [
		{type=WoodsRoom.t.SQUARE, expected={
			size=Vector2(dim, dim),
			position=Vector2(dim, dim)}},
		{type=WoodsRoom.t.LONG, expected={
			size=Vector2(dim*2, dim),
			position=Vector2(dim, dim)}},
		{type=WoodsRoom.t.CLIMB, expected={
			size=Vector2(dim, dim*2),
			position=Vector2(dim, 0)}},
		{type=WoodsRoom.t.FALL, expected={
			size=Vector2(dim, dim*2),
			position=Vector2(dim, dim)}}
		]
	var fall_room = WoodsRoom.create_room({
		type=WoodsRoom.t.FALL,
			contents=room_defs_txt,
		room_base_dim=dim,
		})

	assert_that(len(tests)).is_greater(0)
	for test in tests:
		var room = WoodsRoom.create_room({type=test.type, room_base_dim=dim,
			contents=room_defs_txt,
			last_room=fall_room})
		assert_that(room.rect.size).is_equal(test.expected.size * 3)
		assert_that(room.position).is_equal(test.expected.position * 3)
		room.free()
	fall_room.free()

func test_create_room_after_climb():
	var dim = 16
	var tests = [
		{type=WoodsRoom.t.SQUARE, expected={
			size=Vector2(dim, dim),
			position=Vector2(dim, 0)}},
		{type=WoodsRoom.t.LONG, expected={
			size=Vector2(dim*2, dim),
			position=Vector2(dim, 0)}},
		{type=WoodsRoom.t.CLIMB, expected={
			size=Vector2(dim, dim*2),
			position=Vector2(dim, -1*dim)}},
		{type=WoodsRoom.t.FALL, expected={
			size=Vector2(dim, dim*2),
			position=Vector2(dim, 0)}}
		]
	var climb_room = WoodsRoom.create_room({
		type=WoodsRoom.t.CLIMB,
			contents=room_defs_txt,
		room_base_dim=dim,
		})

	assert_that(len(tests)).is_greater(0)
	for test in tests:
		var room = WoodsRoom.create_room({type=test.type, room_base_dim=dim,
			contents=room_defs_txt, last_room=climb_room})
		assert_that(room.rect.size).is_equal(test.expected.size * 3)
		assert_that(room.position).is_equal(test.expected.position * 3)
		room.free()
	climb_room.free()
