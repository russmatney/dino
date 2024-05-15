@tool
extends Resource
class_name RoomShape

## static ############################################################################

enum T {
	NONE,
	SMALL,
	WIDE,
	WIDE_3,
	WIDE_4,
	TALL,
	TALL_3,
	SQUARE,
	SQUARE_WIDE,
	L,
	L_REVERSE,
	R,
	R_REVERSE,
	T,
	T_INVERTED,
	T_LEFT,
	T_RIGHT,
	}

static var all_room_shapes = {
	T.NONE: [],
	T.SMALL: [Vector3i()],
	T.WIDE: [Vector3i(), Vector3i(1, 0, 0),],
	T.WIDE_3: [Vector3i(), Vector3i(1, 0, 0), Vector3i(2, 0, 0)],
	T.WIDE_4: [Vector3i(), Vector3i(1, 0, 0), Vector3i(2, 0, 0), Vector3i(3, 0, 0)],
	T.TALL: [Vector3i(), Vector3i(0, 1, 0),],
	T.TALL_3: [Vector3i(), Vector3i(0, 1, 0), Vector3i(0, 2, 0)],
	T.SQUARE: [Vector3i(0, 0, 0), Vector3i(1, 0, 0),
		Vector3i(0, 1, 0), Vector3i(1, 1, 0),],
	T.SQUARE_WIDE: [Vector3i(0, 0, 0), Vector3i(1, 0, 0), Vector3i(2, 0, 0),
		Vector3i(0, 1, 0), Vector3i(1, 1, 0), Vector3i(2, 1, 0),
		],
	T.L: [
		Vector3i(0, 0, 0),
		Vector3i(0, 1, 0), Vector3i(1, 1, 0),],
	T.L_REVERSE: [
		Vector3i(0, 0, 0),
		Vector3i(-1, 1, 0), Vector3i(0, 1, 0),],
	T.R: [
		Vector3i(0, 0, 0), Vector3i(1, 0, 0),
		Vector3i(0, 1, 0),],
	T.R_REVERSE: [
		Vector3i(0, 0, 0), Vector3i(1, 0, 0),
		Vector3i(1, 1, 0),],
	T.T: [
		Vector3i(-1, 0, 0), Vector3i(0, 0, 0), Vector3i(1, 0, 0),
							Vector3i(0, 1, 0),],
	T.T_INVERTED: [
							Vector3i(0, -1, 0),
		Vector3i(-1, 0, 0), Vector3i(0, 0, 0), Vector3i(1, 0, 0),],
	T.T_LEFT: [
		Vector3i(0, -1, 0),
		Vector3i(0, 0, 0), Vector3i(1, 0, 0),
		Vector3i(0, 1, 0),],
	T.T_RIGHT: [
							Vector3i(0, -1, 0),
		Vector3i(-1, 0, 0), Vector3i(0, 0, 0),
							Vector3i(0, 1, 0),],
	}

## constructors ############################################################################

static func random_shape() -> RoomShape:
	var rs = RoomShape.new()
	rs.cells.assign(RoomShape.all_room_shapes.values().pick_random())
	return rs

static func small_room() -> RoomShape:
	return RoomShape.new({type=T.SMALL})

static func large_rooms() -> Array[RoomShape]:
	return [
		RoomShape.new({type=T.SQUARE}),
		RoomShape.new({type=T.SQUARE_WIDE}),
		]

static func tall_rooms() -> Array[RoomShape]:
	return [
		RoomShape.new({type=T.TALL}),
		RoomShape.new({type=T.TALL_3}),
		]

static func wide_rooms() -> Array[RoomShape]:
	return [
		RoomShape.new({type=T.WIDE}),
		RoomShape.new({type=T.WIDE_3}),
		RoomShape.new({type=T.WIDE_4}),
		RoomShape.new({type=T.SQUARE}),
		RoomShape.new({type=T.SQUARE_WIDE}),
		]

static func L_rooms() -> Array[RoomShape]:
	return [
		RoomShape.new({type=T.L}),
		RoomShape.new({type=T.L_REVERSE}),
		RoomShape.new({type=T.R}),
		RoomShape.new({type=T.R_REVERSE}),
		]

static func T_rooms() -> Array[RoomShape]:
	return [
		RoomShape.new({type=T.T}),
		RoomShape.new({type=T.T_INVERTED}),
		RoomShape.new({type=T.T_LEFT}),
		RoomShape.new({type=T.T_RIGHT}),
		]

## init ############################################################################

func _init(opts={}):
	if opts.get("cells"):
		cells.assign(opts.get("cells", []))

	if cells.is_empty() and opts.get("type"):
		type = opts.get("type")

## vars ############################################################################

@export var cells: Array[Vector3i]

@export var type: T :
	set(v):
		type = v
		if v in all_room_shapes:
			cells.assign(all_room_shapes.get(v))
		else:
			Log.warn("No room shape found for type", type)
