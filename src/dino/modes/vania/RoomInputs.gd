extends RefCounted
class_name RoomInputs

static var all_entities = ["Blob", "Enemy", "Leaf", "Target", "Candle", "OneWayPlatform"]

static var all_tilemap_scenes = [
		# "res://addons/reptile/tilemaps/GrassTiles16.tscn",
		# "res://addons/reptile/tilemaps/SnowTiles16.tscn",
		# "res://addons/reptile/tilemaps/CaveTiles16.tscn",
		# "res://addons/reptile/tilemaps/PurpleStoneTiles16.tscn",
		"res://addons/reptile/tilemaps/GildedKingdomTiles8.tscn",
		"res://addons/reptile/tilemaps/SpaceshipTiles8.tscn",
		"res://addons/reptile/tilemaps/VolcanoTiles8.tscn",
		"res://addons/reptile/tilemaps/WoodenBoxesTiles8.tscn",
		"res://addons/reptile/tilemaps/GrassyCaveTileMap8.tscn",
	]

static var all_room_shapes = {
	small=[Vector3i()],
	wide=[Vector3i(), Vector3i(1, 0, 0),],
	wide_3=[Vector3i(), Vector3i(1, 0, 0), Vector3i(2, 0, 0)],
	wide_4=[Vector3i(), Vector3i(1, 0, 0), Vector3i(2, 0, 0), Vector3i(3, 0, 0)],
	tall=[Vector3i(), Vector3i(0, 1, 0),],
	tall_3=[Vector3i(), Vector3i(0, 1, 0), Vector3i(0, 2, 0)],
	_4x=[Vector3i(0, 0, 0), Vector3i(1, 0, 0),
		Vector3i(0, 1, 0), Vector3i(1, 1, 0),],
	_4x_wide=[Vector3i(0, 0, 0), Vector3i(1, 0, 0), Vector3i(2, 0, 0),
			Vector3i(0, 1, 0), Vector3i(1, 1, 0), Vector3i(2, 1, 0),
		],
	# [
	# 	Vector3i(0, 0, 0),
	# 	Vector3i(0, 1, 0), Vector3i(1, 1, 0),], # L shape
	# [
	# 	Vector3i(-1, 0, 0), Vector3i(0, 0, 0),
	# 						Vector3i(0, 1, 0),], # 7 shape
	# [
	# 	Vector3i(-1, 0, 0), Vector3i(0, 0, 0), Vector3i(1, 0, 0),
	# 						Vector3i(0, 1, 0),], # T shape
	}

var entities
var room_shape
var room_shapes
var tilemap_scenes
var constraints

func _init(opts={}):
	entities = opts.get("entities", [])
	room_shape = opts.get("room_shape")
	room_shapes = opts.get("room_shapes", [])
	tilemap_scenes = opts.get("tilemap_scenes", [])
	constraints = opts.get("constraints", [])

## merge ######################################################

func merge(b: RoomInputs):
	return RoomInputs.new({
		entities=U.append_array(entities, b.entities),
		room_shape=U._or(b.room_shape, room_shape),
		room_shapes=U.distinct(U.append_array(room_shapes, b.room_shapes)),
		tilemap_scenes=U.distinct(U.append_array(tilemap_scenes, b.tilemap_scenes)),
		constraints=U.append_array(constraints, b.constraints),
		})

## update room def ######################################################

func update_def(def: VaniaRoomDef):
	def.constraints = constraints

	if room_shape:
		def.local_cells = room_shape
	elif not room_shapes.is_empty():
		def.local_cells = room_shapes.pick_random()
	else:
		def.local_cells = all_room_shapes.values().pick_random()

	if not entities.is_empty():
		def.entities = entities

	if not tilemap_scenes.is_empty():
		def.tilemap_scenes = tilemap_scenes
	else:
		def.tilemap_scenes = [all_tilemap_scenes.pick_random()]

## chainable api ######################################################

func overwrite_entities(inp: RoomInputs):
	entities = inp.entities
	return self

func overwrite_room(inp: RoomInputs):
	room_shape = inp.room_shape
	room_shapes = inp.room_shapes
	return self

func overwrite_tilemap(inp: RoomInputs):
	tilemap_scenes = inp.tilemap_scenes
	return self

################################################################
## static ######################################################

static func merge_many(inputs):
	return inputs.reduce(func(a, b): return a.merge(b))

## room components ######################################################33

static func random_entities():
	return RoomInputs.new({
		entities=U.rand_of(all_entities, U.rand_of([2,3,4]))
		})

static func random_room_shapes():
	return RoomInputs.new({
		room_shapes=all_room_shapes.values(),
		})

static func random_tilemaps():
	return RoomInputs.new({
		tilemap_scenes=[
			all_tilemap_scenes.pick_random(),
			all_tilemap_scenes.pick_random(),
			]})

static func random_room():
	return merge_many([random_entities(), random_room_shapes(), random_tilemaps()])

## room size ######################################################33

const IN_LARGE_ROOM = "in_large_room"
const IN_SMALL_ROOM = "in_small_room"

static func large_room():
	return RoomInputs.new({
		room_shape=[all_room_shapes._4x, all_room_shapes._4x_wide].pick_random(),
		constraints=[IN_LARGE_ROOM]
		})

static func small_room():
	return RoomInputs.new({
		room_shape=all_room_shapes.small,
		constraints=[IN_SMALL_ROOM]
		})

## tilemaps ######################################################33

const IN_WOODEN_BOXES = "on_wooden_boxes"
const IN_SPACESHIP = "in_spaceship"
const IN_KINGDOM = "in_kingdom"
const IN_VOLCANO = "in_volcano"
const IN_GRASSY_CAVE = "in_grassy_cave"

static func wooden_boxes():
	return RoomInputs.new({
		tilemap_scenes=["res://addons/reptile/tilemaps/WoodenBoxesTiles8.tscn",],
		constraints=[IN_WOODEN_BOXES]
		})

static func spaceship():
	return RoomInputs.new({
		tilemap_scenes=["res://addons/reptile/tilemaps/SpaceshipTiles8.tscn",],
		constraints=[IN_SPACESHIP]
		})

static func kingdom():
	return RoomInputs.new({
		tilemap_scenes=["res://addons/reptile/tilemaps/GildedKingdomTiles8.tscn",],
		constraints=[IN_KINGDOM]
		})

static func volcano():
	return RoomInputs.new({
		tilemap_scenes=["res://addons/reptile/tilemaps/VolcanoTiles8.tscn",],
		constraints=[IN_VOLCANO]
		})

static func grassy_cave():
	return RoomInputs.new({
		tilemap_scenes=["res://addons/reptile/tilemaps/GrassyCaveTileMap8.tscn",],
		constraints=[IN_GRASSY_CAVE]
		})

## encounters ######################################################33

const HAS_BOSS = "has_boss"
const HAS_ENEMY = "has_enemy"
const HAS_TARGET = "has_target"
const HAS_LEAF = "has_leaf"
const HAS_COOKING_POT = "has_cooking_pot"
const HAS_BLOB = "has_blob"
const HAS_VOID = "has_void"
const HAS_PLAYER = "has_player"

static func boss_room():
	return RoomInputs.new({
		entities=[
			["Monstroar"],
			["Beefstronaut"],
			["Monstroar", "Beefstronaut"]
			].pick_random(),
		constraints=[HAS_BOSS],
		}).merge(large_room())

static func enemy_room():
	return RoomInputs.new({
		entities=[
			["Enemy"],
			["Enemy", "Enemy"],
			["Enemy", "Enemy", "Candle"],
			["Enemy", "Enemy", "Enemy"],
			["Enemy", "Enemy", "Enemy", "Candle"]
			].pick_random(),
		constraints=[HAS_ENEMY],
		})

static func target_room():
	return RoomInputs.new({
		entities=[
			["Target", "Target", "Target", "Target"],
			["Target", "Target", "Target"],
			["Target", "Target", "Target", "Blob"],
			["Target", "Target", "Target", "Target", "Enemy"],
			].pick_random(),
		constraints=[HAS_TARGET],
		})

static func leaf_room():
	return RoomInputs.new({
		entities=[
			["Leaf", "Leaf", "Leaf", "Leaf", "Leaf", "Candle"],
			["Leaf", "Leaf", "Leaf", "Leaf", "Candle"],
			["Leaf", "Leaf", "Leaf", "Candle"],
			].pick_random(),
		constraints=[HAS_LEAF],
		})

static func cooking_room():
	return RoomInputs.new({
		entities=[
			["Blob", "CookingPot", "Void"],
			["Blob", "Blob", "CookingPot", "Void"],
			].pick_random(),
		constraints=[HAS_COOKING_POT, HAS_BLOB, HAS_VOID],
		}).merge(large_room())

static func player_room():
	return RoomInputs.new({
		entities=[
			["Player"],
			["Player", "Candle"],
			].pick_random(),
		constraints=[HAS_PLAYER],
		}).merge(small_room())
