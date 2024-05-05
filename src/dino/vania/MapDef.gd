extends Resource
class_name MapDef

## vars #######################################################

@export var name: String
@export var inputs: Array[RoomInput]

## init #######################################################

func _init(opts={}):
	name = opts.get("name", "New Map Def")
	inputs.assign(opts.get("inputs", []))

## static #######################################################

static func spawn_room(_opts={}) -> MapDef:
	return MapDef.new({inputs=[
		RoomInput.merge_many([
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.PLAYERSPAWNPOINT,
				DinoEntityIds.CANDLE,
			]}),
			RoomInput.small_room_shape(),
		]),
	]})

static func random_room(_opts={}) -> MapDef:
	return MapDef.new({inputs=[RoomInput.random_room()]})

static func random_rooms(opts={}) -> MapDef:
	var rooms = U.repeat_fn(RoomInput.random_room, opts.get("count", U.rand_of([2, 3, 4])))
	return MapDef.new({inputs=rooms})

## encounters ######################################################33

static func cooking_room(_opts={}):
	return RoomInput.with({
		entity_ids=[DinoEntityIds.COOKINGPOT, DinoEntityIds.VOID],
		enemy_ids=[EnemyIds.BLOB],
		})

static func harvey_room(_opts={}):
	return RoomInput.with({
		entity_ids=[
			DinoEntityIds.TOOL,
			DinoEntityIds.SUPPLYBOX,
			DinoEntityIds.SUPPLYBOX,
			DinoEntityIds.PLOT,
			DinoEntityIds.PLOT,
			DinoEntityIds.DELIVERYBOX,
			DinoEntityIds.ACTIONBOT,
			DinoEntityIds.ACTIONBOT,
			],
		}).merge(RoomInput.topdown())
