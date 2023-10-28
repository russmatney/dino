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

var room_defs_path = "res://test/woods/room_defs_test.txt"

## setup ###########################################################

func before_all():
	var file = FileAccess.open(room_defs_path, FileAccess.WRITE)
	file.store_string(room_defs_txt)

## create_room ###########################################################

func test_create_room_empty_dict():
	var room = WoodsRoom.create_room({
		room_defs_path=room_defs_path,
		filler_tile_count=0})

	assert_that(room.position).is_equal(Vector2.ZERO)
	assert_that(room.type).is_equal(WoodsRoom.t.SQUARE)
	assert_that(room.room_def.meta.room_type).is_equal("SQUARE")
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
		filler_tile_count=0,
		room_defs_path=room_defs_path,
		type=WoodsRoom.t.START,
		})

	assert_that(room.position).is_equal(Vector2.ZERO)
	assert_that(room.type).is_equal(WoodsRoom.t.START)
	assert_that(room.room_def.meta.room_type).is_equal("START")
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
		filler_tile_count=0,
		room_defs_path=room_defs_path,
		type=WoodsRoom.t.END,
		})

	assert_that(room.position).is_equal(Vector2.ZERO)
	assert_that(room.type).is_equal(WoodsRoom.t.END)
	assert_that(room.room_def.meta.room_type).is_equal("END")
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
		filler_tile_count=0,
		room_defs_path=room_defs_path,
		type=WoodsRoom.t.SQUARE,
		})

	assert_that(room.position).is_equal(Vector2.ZERO)
	assert_that(room.type).is_equal(WoodsRoom.t.SQUARE)
	assert_that(room.room_def.meta.room_type).is_equal("SQUARE")
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
		filler_tile_count=0,
		room_defs_path=room_defs_path,
		type=WoodsRoom.t.LONG,
		})

	assert_that(room.position).is_equal(Vector2.ZERO)
	assert_that(room.type).is_equal(WoodsRoom.t.LONG)
	assert_that(room.room_def.meta.room_type).is_equal("LONG")
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
		room_defs_path=room_defs_path,
		room_base_dim=dim,
		})

	var square_room = WoodsRoom.create_room({
		type=WoodsRoom.t.SQUARE,
		room_defs_path=room_defs_path,
		room_base_dim=dim,
		})

	assert_that(len(tests)).is_greater(0)
	for test in tests:
		var room = WoodsRoom.create_room({type=test.type, room_base_dim=dim,
			room_defs_path=room_defs_path,
			}, start_room)
		assert_that(room.rect.size).is_equal(test.expected.size)
		assert_that(room.position).is_equal(test.expected.position)

		var room_sq = WoodsRoom.create_room({type=test.type, room_base_dim=dim,
			room_defs_path=room_defs_path,
			}, square_room)
		assert_that(room_sq.rect.size).is_equal(test.expected.size)
		assert_that(room_sq.position).is_equal(test.expected.position)
		room.free()
		room_sq.free()
	start_room.free()
	square_room.free()

func test_create_room_after_long():
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
	var long_room = WoodsRoom.create_room({
		type=WoodsRoom.t.LONG,
		room_defs_path=room_defs_path,
		room_base_dim=dim,
		})

	assert_that(len(tests)).is_greater(0)
	for test in tests:
		var room = WoodsRoom.create_room({type=test.type, room_base_dim=dim,
			room_defs_path=room_defs_path,
			}, long_room)
		assert_that(room.rect.size).is_equal(test.expected.size)
		assert_that(room.position).is_equal(test.expected.position)
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
			position=Vector2(dim, -1*dim)}},
		{type=WoodsRoom.t.FALL, expected={
			size=Vector2(dim, dim*2),
			position=Vector2(dim, dim)}}
		]
	var fall_room = WoodsRoom.create_room({
		type=WoodsRoom.t.FALL,
		room_defs_path=room_defs_path,
		room_base_dim=dim,
		})

	assert_that(len(tests)).is_greater(0)
	for test in tests:
		var room = WoodsRoom.create_room({type=test.type, room_base_dim=dim,
			room_defs_path=room_defs_path,
			}, fall_room)
		assert_that(room.rect.size).is_equal(test.expected.size)
		assert_that(room.position).is_equal(test.expected.position)
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
			position=Vector2(dim, -2*dim)}},
		{type=WoodsRoom.t.FALL, expected={
			size=Vector2(dim, dim*2),
			position=Vector2(dim, 0)}}
		]
	var climb_room = WoodsRoom.create_room({
		type=WoodsRoom.t.CLIMB,
		room_defs_path=room_defs_path,
		room_base_dim=dim,
		})

	assert_that(len(tests)).is_greater(0)
	for test in tests:
		var room = WoodsRoom.create_room({type=test.type, room_base_dim=dim,
			room_defs_path=room_defs_path,
			}, climb_room)
		assert_that(room.rect.size).is_equal(test.expected.size)
		assert_that(room.position).is_equal(test.expected.position)
		room.free()
	climb_room.free()
