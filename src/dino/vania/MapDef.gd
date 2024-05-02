extends Resource
class_name MapDef

## vars #######################################################

@export var name: String
@export var room_inputs: Array[RoomInput]

## init #######################################################

func _init(opts={}):
	name = opts.get("name", "New Map Def")
	room_inputs.assign(opts.get("room_inputs", []))

## static #######################################################

static func spawn_room(_opts={}) -> MapDef:
	return MapDef.new({room_inputs=[
		RoomInput.merge_many([
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.PLAYERSPAWNPOINT,
				DinoEntityIds.CANDLE,
			]}),
			RoomInput.small_room_shape(),
		]),
	]})

static func random_room(_opts={}) -> MapDef:
	return MapDef.new({room_inputs=[RoomInput.random_room()]})

static func random_rooms(opts={}) -> MapDef:
	var rooms = U.repeat_fn(RoomInput.random_room, opts.get("count", U.rand_of([2, 3, 4])))
	return MapDef.new({room_inputs=rooms})
