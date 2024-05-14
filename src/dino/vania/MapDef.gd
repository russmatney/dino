extends Resource
class_name MapDef

## vars #######################################################

# name of the mapDef
@export var name: String

# inputs to be used in any room
@export var input: MapInput

# inputs for specific rooms and specific items in them
# TODO do we want metadata on these? or is that just more MapInput fields?
@export var rooms: Array[MapInput]

# sub map_defs for complex map generation
@export var sub_map_defs: Array[MapDef]

## init #######################################################

func _init(opts={}):
	name = opts.get("name", "New Map Def")

func new_game_node(opts={}):
	return VaniaGame.create_game_node(self, opts)

func to_pretty():
	return [name, {input=input, rooms=rooms}]

############################################################
## static #######################################################

## encounters ######################################################33

static func cooking_room(_opts={}) -> MapInput:
	return MapInput.with({
		entity_ids=[DinoEntityIds.COOKINGPOT, DinoEntityIds.VOID],
		enemy_ids=[EnemyIds.BLOB],
		})

static func harvey_room(_opts={}) -> MapInput:
	return MapInput.with({
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
		}).merge(MapInput.topdown())

## static map defs ######################################################33

static func with_inputs(rms: Array[MapInput]):
	var def = MapDef.new()
	def.rooms = rms
	return def

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
	return MapDef.new({rooms=[
		MapInput.merge_many([
			MapInput.has_entities({entity_ids=[
				DinoEntityIds.PLAYERSPAWNPOINT,
				DinoEntityIds.CANDLE,
			]}),
			MapInput.small_room_shape(),
		]),
	]})

static func random_room(_opts={}) -> MapDef:
	return MapDef.new({rooms=[MapInput.random_room()]})

static func random_rooms(opts={}) -> MapDef:
	var inpts = U.repeat_fn(MapInput.random_room, opts.get("count", U.rand_of([2, 3, 4])))
	return MapDef.new({rooms=inpts})

static func default_game(_opts={}) -> MapDef:
	var inpts = [
		MapInput.merge_many([
			MapInput.has_entities({entity_ids=[
				DinoEntityIds.PLAYERSPAWNPOINT,
				DinoEntityIds.CANDLE,
				DinoEntityIds.HANGINGLIGHT,
				DinoEntityIds.BUSH2,
			]}),
			MapInput.small_room_shape(),
			MapInput.has_effects({effects=[
				RoomEffect.snow_fall(),
				RoomEffect.rain_fall(),
			]}),
		]),
		MapInput.merge_many([
			MapInput.random_room(),
			MapInput.has_effects({effects=[
				RoomEffect.snow_fall(),
			]}),
			MapInput.has_entities({entity_ids=[
				DinoEntityIds.HANGINGLIGHT,
				DinoEntityIds.BUSH1,
			]}),
		]),
		MapInput.merge_many([
			MapInput.random_room(),
			MapInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			MapInput.has_entities({entity_ids=[
				DinoEntityIds.HANGINGLIGHT,
				DinoEntityIds.BUSH1,
				DinoEntityIds.BUSH2,
			]}),
		]),
		MapDef.cooking_room(),
	]
	inpts.append_array(U.repeat_fn(MapInput.random_room, 3))

	return MapDef.new({name="Default Vania", rooms=inpts})

# village def
#

static func village(_opts={}) -> MapDef:
	return MapDef.new({
		name="Village",
		rooms=[MapInput.with({
			entity_ids=[
				DinoEntityIds.PLAYERSPAWNPOINT,

				# villager
				DinoEntityIds.VILLAGERDUAA,
				DinoEntityIds.VILLAGERGREG,
				DinoEntityIds.VILLAGERCAMERON,
				DinoEntityIds.VILLAGERRUSS,
				DinoEntityIds.VILLAGER,
				DinoEntityIds.VILLAGER,
				DinoEntityIds.VILLAGER,
				DinoEntityIds.VILLAGER,
				DinoEntityIds.VILLAGER,

				# herd
				# DinoEntityIds.SHEEP,
				# DinoEntityIds.SHEEP,
				# DinoEntityIds.SHEEP,

				# leaves
				# DinoEntityIds.LEAFGOD,

				# harvey
				# DinoEntityIds.TOOL,
				# DinoEntityIds.SUPPLYBOX,
				# DinoEntityIds.PLOT,
				# DinoEntityIds.DELIVERYBOX,
				# DinoEntityIds.ACTIONBOT,

				# arcade
				# DinoEntityIds.COIN,
				# DinoEntityIds.COIN,
				# DinoEntityIds.COIN,
				# DinoEntityIds.ARCADEMACHINE,

				# gems
				# DinoEntityIds.GEM,
				# DinoEntityIds.GEM,
				DinoEntityIds.BOX,
				DinoEntityIds.BOX,
				DinoEntityIds.BOX,
				DinoEntityIds.BOX,

				DinoEntityIds.COOKINGPOT,
				DinoEntityIds.CANDLE,
				DinoEntityIds.CANDLE,
				DinoEntityIds.CANDLE,
				DinoEntityIds.CANDLE,
				# DinoEntityIds.HANGINGLIGHT,
				# DinoEntityIds.HANGINGLIGHT,
				# DinoEntityIds.HANGINGLIGHT,
				# DinoEntityIds.HANGINGLIGHT,
				DinoEntityIds.BUSH1,
				DinoEntityIds.BUSH1,
				DinoEntityIds.BUSH1,
				DinoEntityIds.BUSH2,
				DinoEntityIds.BUSH2,
				DinoEntityIds.BUSH2,
				],
			}).merge(MapInput.large_room_shape())\
			.merge(MapInput.has_snow_fall())\
			.merge(MapInput.topdown())
			]})

static func topdown_game(_opts={}) -> MapDef:
	var inpts = [
		MapInput.merge_many([
			MapInput.topdown(),
			MapInput.has_entities({entity_ids=[
				DinoEntityIds.PLAYERSPAWNPOINT,
			]}),
			MapInput.small_room_shape(),
			MapInput.has_effects({effects=[
				RoomEffect.dust(),
			]}),
		]),
		MapDef.harvey_room(),
	]
	inpts.append_array(U.repeat_fn(func():
		return MapInput.random_room().merge(MapInput.topdown()),
		3))
	return MapDef.new({name="TopDown Game", rooms=inpts})

static func mixed_genre_game(_opts={}) -> MapDef:
	var inpts = [
		MapInput.merge_many([
			MapInput.sidescroller(),
			MapInput.has_entities({entity_ids=[DinoEntityIds.PLAYERSPAWNPOINT]}),
			MapInput.small_room_shape(),
		]),
		MapInput.merge_many([
			MapInput.topdown(),
			MapInput.small_room_shape(),
			MapInput.has_effects({effects=[RoomEffect.dust()]}),
		]),
		MapInput.merge_many([
			MapInput.sidescroller(),
		]),
		MapInput.merge_many([
			MapInput.topdown(),
			MapInput.has_effects({effects=[RoomEffect.dust()]}),
		]),
		MapInput.merge_many([
			MapInput.sidescroller(),
			MapInput.has_effects({effects=[RoomEffect.rain_fall()]}),
		]),
		MapInput.merge_many([
			MapInput.topdown(),
			MapInput.has_effects({effects=[RoomEffect.dust()]}),
		]),
	]
	return MapDef.new({name="Mixed Genre Game", rooms=inpts})

static func tower_game(_opts={}) -> MapDef:
	return MapDef.new({
		name="Tower",
		rooms=[
			MapInput.merge_many([
				MapInput.has_entities({entity_ids=[
					DinoEntityIds.PLAYERSPAWNPOINT,
					DinoEntityIds.TARGET,
					DinoEntityIds.TARGET,
					DinoEntityIds.TARGET,
				]}),
				MapInput.wide_room_shape(),
				MapInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			]),
			MapInput.merge_many([
				MapInput.has_entities({entity_ids=[
					DinoEntityIds.TARGET,
					DinoEntityIds.TARGET,
					DinoEntityIds.TARGET,
				]}),
				MapInput.large_room_shape(),
				MapInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			]),
			MapInput.merge_many([
				MapInput.has_entities({entity_ids=[
					DinoEntityIds.TARGET,
					DinoEntityIds.TARGET,
					DinoEntityIds.TARGET,
				]}),
				MapInput.tall_room_shape(),
				MapInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			]),
		]})

static func woods_game(_opts={}) -> MapDef:
	return MapDef.new({
		name="Woods",
		rooms=[
			MapInput.merge_many([
				MapInput.has_entities({entity_ids=[
					DinoEntityIds.PLAYERSPAWNPOINT,
					DinoEntityIds.LEAF,
					DinoEntityIds.LEAF,
					DinoEntityIds.LEAF,
				]}),
				MapInput.wide_room_shape(),
				MapInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			]),
			MapInput.merge_many([
				MapInput.has_entities({entity_ids=[
					DinoEntityIds.LEAF,
					DinoEntityIds.LEAF,
					DinoEntityIds.LEAF,
				]}),
				MapInput.large_room_shape(),
				MapInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			]),
			MapInput.merge_many([
				MapInput.has_entities({entity_ids=[
					DinoEntityIds.LEAF,
					DinoEntityIds.LEAF,
					DinoEntityIds.LEAF,
					DinoEntityIds.LEAFGOD,
				]}),
				MapInput.tall_room_shape(),
				MapInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			]),
		]})

static func arcade_game(_opts={}) -> MapDef:
	return MapDef.new({
		name="Arcade",
		rooms=[
			MapInput.merge_many([
				MapInput.has_entities({entity_ids=[
					DinoEntityIds.PLAYERSPAWNPOINT,
					DinoEntityIds.COIN,
					DinoEntityIds.COIN,
					DinoEntityIds.COIN,
					DinoEntityIds.ARCADEMACHINE,
				]}),
				MapInput.wide_room_shape(),
				MapInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			]),
			MapInput.merge_many([
				MapInput.has_entities({entity_ids=[
					DinoEntityIds.COIN,
					DinoEntityIds.COIN,
					DinoEntityIds.COIN,
					DinoEntityIds.ARCADEMACHINE,
				]}),
				MapInput.large_room_shape(),
				MapInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			]),
			MapInput.merge_many([
				MapInput.has_entities({entity_ids=[
					DinoEntityIds.COIN,
					DinoEntityIds.COIN,
					DinoEntityIds.COIN,
					DinoEntityIds.ARCADEMACHINE,
				]}),
				MapInput.tall_room_shape(),
				MapInput.has_effects({effects=[RoomEffect.rain_fall()]}),
			]),
		]})
