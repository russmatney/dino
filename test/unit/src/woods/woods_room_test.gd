extends GutTest

# TODO add to gut or some gut util
func assert_eq_set(a, b):
	a.sort()
	b.sort()
	assert_eq_deep(a, b)

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
"

var room_defs_path = "res://test/unit/src/woods/room_defs_test.txt"

## setup ###########################################################

func before_all():
	var file = FileAccess.open(room_defs_path, FileAccess.WRITE)
	file.store_string(room_defs_txt)

## create room ###########################################################

func test_create_room_empty_dict():
	var room = WoodsRoom.create_room({room_defs_path=room_defs_path})

	assert_eq(room.position, Vector2.ZERO)
	assert_eq(room.room_def.room_type, "SQUARE")
	assert_eq_set(room.tilemap.get_used_cells(0), [
		Vector2i(0, 2),
		Vector2i(1, 2),
		Vector2i(2, 2),
		Vector2i(2, 0),
		Vector2i(1, 0),
		Vector2i(0, 0),
		])

func test_create_room_start():
	var room = WoodsRoom.create_room({
		room_defs_path=room_defs_path,
		type=WoodsRoom.t.START,
		})

	assert_eq(room.position, Vector2.ZERO)
	assert_eq(room.room_def.room_type, "START")
	assert_eq_set(room.tilemap.get_used_cells(0), [
		Vector2i(0, 2),
		Vector2i(0, 1),
		Vector2i(0, 0),
		Vector2i(1, 0),
		Vector2i(1, 2),
		Vector2i(2, 0),
		Vector2i(2, 2),
		])

func test_create_room_end():
	var room = WoodsRoom.create_room({
		room_defs_path=room_defs_path,
		type=WoodsRoom.t.END,
		})

	assert_eq(room.position, Vector2.ZERO)
	assert_eq(room.room_def.room_type, "END")
	assert_eq_set(room.tilemap.get_used_cells(0), [
		Vector2i(0, 2),
		Vector2i(0, 0),
		Vector2i(1, 0),
		Vector2i(1, 2),
		Vector2i(2, 0),
		Vector2i(2, 1),
		Vector2i(2, 2),
		])

func test_create_room_square():
	var room = WoodsRoom.create_room({
		room_defs_path=room_defs_path,
		type=WoodsRoom.t.SQUARE,
		})

	assert_eq(room.position, Vector2.ZERO)
	assert_eq(room.room_def.room_type, "SQUARE")
	assert_eq_set(room.tilemap.get_used_cells(0), [
		Vector2i(0, 2),
		Vector2i(1, 2),
		Vector2i(2, 2),
		Vector2i(2, 0),
		Vector2i(1, 0),
		Vector2i(0, 0),
		])

func test_create_room_long():
	var room = WoodsRoom.create_room({
		room_defs_path=room_defs_path,
		type=WoodsRoom.t.LONG,
		})

	assert_eq(room.position, Vector2.ZERO)
	assert_eq(room.room_def.room_type, "LONG")
	assert_eq_set(room.tilemap.get_used_cells(0), [
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
