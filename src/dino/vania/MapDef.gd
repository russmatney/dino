extends Resource
class_name MapDef

## vars #######################################################

@export var name: String
@export var inputs: Array[RoomInput]

## init #######################################################

func _init(opts={}):
	name = opts.get("name", "New Map Def")
	inputs.assign(opts.get("inputs", []))


############################################################
## static #######################################################

## encounters ######################################################33

static func cooking_room(_opts={}) -> RoomInput:
	return RoomInput.with({
		entity_ids=[DinoEntityIds.COOKINGPOT, DinoEntityIds.VOID],
		enemy_ids=[EnemyIds.BLOB],
		})

static func harvey_room(_opts={}) -> RoomInput:
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

## static map defs ######################################################33

static func all_map_defs():
	return [
		default_game(),
		topdown_game(),
		mixed_genre_game(),
		village(),
		arcade_game(),
		woods_game(),
		tower_game(),
	]

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

static func default_game(_opts={}) -> MapDef:
	var inpts = [
		RoomInput.merge_many([
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.PLAYERSPAWNPOINT,
				DinoEntityIds.CANDLE,
				DinoEntityIds.HANGINGLIGHT,
				DinoEntityIds.BUSH2,
			]}),
			RoomInput.small_room_shape(),
			RoomInput.has_effects({effects=[
				RoomEffect.snow_fall(),
				RoomEffect.rain_fall(),
			]}),
		]),
		RoomInput.merge_many([
			RoomInput.random_room(),
			RoomInput.has_effects({effects=[
				RoomEffect.snow_fall(),
			]}),
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.HANGINGLIGHT,
				DinoEntityIds.BUSH1,
			]}),
		]),
		RoomInput.merge_many([
			RoomInput.random_room(),
			RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.HANGINGLIGHT,
				DinoEntityIds.BUSH1,
				DinoEntityIds.BUSH2,
			]}),
		]),
		MapDef.cooking_room(),
	]
	inpts.append_array(U.repeat_fn(RoomInput.random_room, 3))

	return MapDef.new({name="Vania", inputs=inpts})

static func village(_opts={}) -> MapDef:
	return MapDef.new({
		inputs=[RoomInput.with({
			entity_ids=[
				DinoEntityIds.PLAYERSPAWNPOINT,
				DinoEntityIds.SHEEP,
				DinoEntityIds.SHEEP,
				DinoEntityIds.SHEEP,
				DinoEntityIds.LEAFGOD,
				# DinoEntityIds.TOOL,
				# DinoEntityIds.SUPPLYBOX,
				# DinoEntityIds.PLOT,
				# DinoEntityIds.DELIVERYBOX,
				# DinoEntityIds.ACTIONBOT,
				DinoEntityIds.COIN,
				DinoEntityIds.COIN,
				DinoEntityIds.COIN,
				DinoEntityIds.GEM,
				DinoEntityIds.GEM,
				DinoEntityIds.BOX,
				DinoEntityIds.BOX,
				DinoEntityIds.BOX,
				DinoEntityIds.BOX,
				DinoEntityIds.COOKINGPOT,
				DinoEntityIds.ARCADEMACHINE,
				DinoEntityIds.CANDLE,
				DinoEntityIds.CANDLE,
				DinoEntityIds.CANDLE,
				DinoEntityIds.CANDLE,
				DinoEntityIds.HANGINGLIGHT,
				DinoEntityIds.HANGINGLIGHT,
				DinoEntityIds.HANGINGLIGHT,
				DinoEntityIds.HANGINGLIGHT,
				DinoEntityIds.BUSH1,
				DinoEntityIds.BUSH1,
				DinoEntityIds.BUSH1,
				DinoEntityIds.BUSH2,
				DinoEntityIds.BUSH2,
				DinoEntityIds.BUSH2,
				],
			}).merge(RoomInput.large_room_shape()
				).merge(RoomInput.has_snow_fall())
			]})

static func topdown_game(_opts={}) -> MapDef:
	var inpts = [
		RoomInput.merge_many([
			RoomInput.topdown(),
			RoomInput.has_entities({entity_ids=[
				DinoEntityIds.PLAYERSPAWNPOINT,
			]}),
			RoomInput.small_room_shape(),
			RoomInput.has_effects({effects=[
				RoomEffect.dust(),
			]}),
		]),
		MapDef.harvey_room(),
	]
	inpts.append_array(U.repeat_fn(func():
		return RoomInput.random_room().merge(RoomInput.topdown()),
		3))
	return MapDef.new({name="TopDown Game", inputs=inpts})

static func mixed_genre_game(_opts={}) -> MapDef:
	var inpts = [
		RoomInput.merge_many([
			RoomInput.sidescroller(),
			RoomInput.has_entities({entity_ids=[DinoEntityIds.PLAYERSPAWNPOINT]}),
			RoomInput.small_room_shape(),
		]),
		RoomInput.merge_many([
			RoomInput.topdown(),
			RoomInput.small_room_shape(),
			RoomInput.has_effects({effects=[RoomEffect.dust()]}),
		]),
		RoomInput.merge_many([
			RoomInput.sidescroller(),
		]),
		RoomInput.merge_many([
			RoomInput.topdown(),
			RoomInput.has_effects({effects=[RoomEffect.dust()]}),
		]),
		RoomInput.merge_many([
			RoomInput.sidescroller(),
			RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
		]),
		RoomInput.merge_many([
			RoomInput.topdown(),
			RoomInput.has_effects({effects=[RoomEffect.dust()]}),
		]),
	]
	return MapDef.new({name="Mixed Genre Game", inputs=inpts})

static func tower_game(_opts={}) -> MapDef:
	return MapDef.new({
		name="Tower",
		inputs=[
			RoomInput.merge_many([
				RoomInput.has_entities({entity_ids=[
					DinoEntityIds.PLAYERSPAWNPOINT,
					DinoEntityIds.TARGET,
					DinoEntityIds.TARGET,
					DinoEntityIds.TARGET,
				]}),
				RoomInput.wide_room_shape(),
				RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			]),
			RoomInput.merge_many([
				RoomInput.has_entities({entity_ids=[
					DinoEntityIds.TARGET,
					DinoEntityIds.TARGET,
					DinoEntityIds.TARGET,
				]}),
				RoomInput.large_room_shape(),
				RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			]),
			RoomInput.merge_many([
				RoomInput.has_entities({entity_ids=[
					DinoEntityIds.TARGET,
					DinoEntityIds.TARGET,
					DinoEntityIds.TARGET,
				]}),
				RoomInput.tall_room_shape(),
				RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			]),
		]})

static func woods_game(_opts={}) -> MapDef:
	return MapDef.new({
		name="Woods",
		inputs=[
			RoomInput.merge_many([
				RoomInput.has_entities({entity_ids=[
					DinoEntityIds.PLAYERSPAWNPOINT,
					DinoEntityIds.LEAF,
					DinoEntityIds.LEAF,
					DinoEntityIds.LEAF,
				]}),
				RoomInput.wide_room_shape(),
				RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			]),
			RoomInput.merge_many([
				RoomInput.has_entities({entity_ids=[
					DinoEntityIds.LEAF,
					DinoEntityIds.LEAF,
					DinoEntityIds.LEAF,
				]}),
				RoomInput.large_room_shape(),
				RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			]),
			RoomInput.merge_many([
				RoomInput.has_entities({entity_ids=[
					DinoEntityIds.LEAF,
					DinoEntityIds.LEAF,
					DinoEntityIds.LEAF,
					DinoEntityIds.LEAFGOD,
				]}),
				RoomInput.tall_room_shape(),
				RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			]),
		]})

static func arcade_game(_opts={}) -> MapDef:
	return MapDef.new({
		name="Arcade",
		inputs=[
			RoomInput.merge_many([
				RoomInput.has_entities({entity_ids=[
					DinoEntityIds.PLAYERSPAWNPOINT,
					DinoEntityIds.COIN,
					DinoEntityIds.COIN,
					DinoEntityIds.COIN,
					DinoEntityIds.ARCADEMACHINE,
				]}),
				RoomInput.wide_room_shape(),
				RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			]),
			RoomInput.merge_many([
				RoomInput.has_entities({entity_ids=[
					DinoEntityIds.COIN,
					DinoEntityIds.COIN,
					DinoEntityIds.COIN,
					DinoEntityIds.ARCADEMACHINE,
				]}),
				RoomInput.large_room_shape(),
				RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			]),
			RoomInput.merge_many([
				RoomInput.has_entities({entity_ids=[
					DinoEntityIds.COIN,
					DinoEntityIds.COIN,
					DinoEntityIds.COIN,
					DinoEntityIds.ARCADEMACHINE,
				]}),
				RoomInput.tall_room_shape(),
				RoomInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			]),
		]})
