extends RefCounted
class_name RoomInputs

static var all_entities = [
	"Blob", "Enemy", "Leaf", "Target", "Candle", "OneWayPlatform",
	"Void", "CookingPot", "Monstroar", "Beefstronaut"
	]

static var all_tilemap_scenes = [
		# "res://addons/core/reptile/tilemaps/GrassTiles16.tscn",
		# "res://addons/core/reptile/tilemaps/SnowTiles16.tscn",
		# "res://addons/core/reptile/tilemaps/CaveTiles16.tscn",
		# "res://addons/core/reptile/tilemaps/PurpleStoneTiles16.tscn",
		"res://addons/core/reptile/tilemaps/GildedKingdomTiles8.tscn",
		"res://addons/core/reptile/tilemaps/SpaceshipTiles8.tscn",
		"res://addons/core/reptile/tilemaps/VolcanoTiles8.tscn",
		"res://addons/core/reptile/tilemaps/WoodenBoxesTiles8.tscn",
		"res://addons/core/reptile/tilemaps/GrassyCaveTileMap8.tscn",
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
	L_shape=[
		Vector3i(0, 0, 0),
		Vector3i(0, 1, 0), Vector3i(1, 1, 0),],
	L_backwards_shape=[
							Vector3i(0, 0, 0),
		Vector3i(-1, 1, 0), Vector3i(0, 1, 0),],
	r_shape=[
		Vector3i(0, 0, 0), Vector3i(1, 0, 0),
		Vector3i(0, 1, 0),],
	r_backwards_shape=[
		Vector3i(0, 0, 0), Vector3i(1, 0, 0),
							Vector3i(1, 1, 0),],
	T_shape=[
		Vector3i(-1, 0, 0), Vector3i(0, 0, 0), Vector3i(1, 0, 0),
							Vector3i(0, 1, 0),],
	T_inverted_shape=[
							Vector3i(0, -1, 0),
		Vector3i(-1, 0, 0), Vector3i(0, 0, 0), Vector3i(1, 0, 0),],
	half_H_shape=[
		Vector3i(0, -1, 0),
		Vector3i(0, 0, 0), Vector3i(1, 0, 0),
		Vector3i(0, 1, 0),],
	half_H_backwards_shape=[Vector3i(0, -1, 0),
		Vector3i(-1, 0, 0), Vector3i(0, 0, 0),
							Vector3i(0, 1, 0),],
	}

static var all_constraints = [
	# room shapes are not editable
	# IN_LARGE_ROOM,
	# IN_SMALL_ROOM,
	# IN_TALL_ROOM,
	# IN_WIDE_ROOM,
	# IN_T_ROOM,
	# IN_L_ROOM,
	# CUSTOM_ROOM,
	IN_WOODEN_BOXES,
	IN_SPACESHIP,
	IN_KINGDOM,
	IN_VOLCANO,
	IN_GRASSY_CAVE,
	HAS_BOSS,
	HAS_ENEMY,
	HAS_TARGET,
	HAS_LEAF,
	IS_COOKING_ROOM,
	HAS_COOKING_POT,
	HAS_BLOB,
	HAS_VOID,
	HAS_PLAYER,
	HAS_CANDLE,
	HAS_CHECKPOINT,
	]

var entities
var room_shape
var room_shapes
var tilemap_scenes

func _init(opts={}):
	entities = opts.get("entities", [])
	room_shape = opts.get("room_shape")
	room_shapes = opts.get("room_shapes", [])
	tilemap_scenes = opts.get("tilemap_scenes", [])

func to_printable():
	return {
		entities=entities,
		tilemap_scenes=tilemap_scenes,
		room_shape=room_shape,
		room_shapes=room_shapes,
		}

## merge ######################################################

func merge(b: RoomInputs):
	return RoomInputs.new({
		entities=U.append_array(entities, b.entities),
		room_shape=U._or(b.room_shape, room_shape),
		room_shapes=U.distinct(U.append_array(room_shapes, b.room_shapes)),
		tilemap_scenes=U.distinct(U.append_array(tilemap_scenes, b.tilemap_scenes)),
		})

## update room def ######################################################

func update_def(def: VaniaRoomDef):
	if room_shape:
		def.set_local_cells(room_shape)
	elif not room_shapes.is_empty():
		def.set_local_cells(room_shapes.pick_random())
	else:
		def.set_local_cells(all_room_shapes.values().pick_random())

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

static func apply_constraints(conses, def: VaniaRoomDef):
	var existing_shape = def.local_cells

	if conses is RoomInputs:
		def.constraints = [conses]

		conses.update_def(def)
		if existing_shape != null and not existing_shape.is_empty():
			# maintain current local_cells
			def.set_local_cells(existing_shape)
		return conses

	if conses is Dictionary:
		conses = [conses]

	if not conses is Array:
		Log.warn("Unhandled constraint collection passed to apply_constraints, aborting", conses)
		return

	def.constraints = conses
	var ri = conses.map(func(cons):
		# map constants to dicts with default opts
		if cons is String:
			return {cons: {}}
		elif cons is Dictionary:
			return cons
		else:
			Log.warn("Unhandled constraint passed to apply_constraints, ignoring", cons)
			return null
		).reduce(
			func(agg_inp, cons_dict):
				if cons_dict == null:
					return agg_inp
				# apply each constraint_dict in succession
				return RoomInputs.apply_constraint(agg_inp, cons_dict),
			RoomInputs.new())

	ri.update_def(def)

	if existing_shape != null and not existing_shape.is_empty():
		# maintain pre-existing local_cells
		def.set_local_cells(existing_shape)
	return ri

static func apply_constraint(inp: RoomInputs, cons_dict):
	for k in cons_dict.keys():
		var cons_inp = RoomInputs.get_constraint_data(k, cons_dict.get(k))
		inp = inp.merge(cons_inp)
	return inp

static func get_constraint_data(cons_key, opts={}):
	match cons_key:
		IN_LARGE_ROOM: return large_room_shape(opts)
		IN_SMALL_ROOM: return small_room_shape(opts)
		IN_TALL_ROOM: return tall_room_shape(opts)
		IN_WIDE_ROOM: return wide_room_shape(opts)
		IN_T_ROOM: return T_room_shape(opts)
		IN_L_ROOM: return L_room_shape(opts)
		CUSTOM_ROOM: return custom_room_shape(opts)

		IN_WOODEN_BOXES: return wooden_boxes(opts)
		IN_SPACESHIP: return spaceship(opts)
		IN_KINGDOM: return kingdom(opts)
		IN_VOLCANO: return volcano(opts)
		IN_GRASSY_CAVE: return grassy_cave(opts)

		IS_COOKING_ROOM: return cooking_room(opts)

		HAS_BOSS: return has_boss(opts)

		HAS_ENEMY: return has_entity("Enemy", opts)
		HAS_TARGET: return has_entity("Target", opts)
		HAS_LEAF: return has_entity("Leaf", opts)
		HAS_CANDLE: return has_entity("Candle", opts)
		HAS_CHECKPOINT: return has_entity("Checkpoint", opts)
		HAS_PLAYER: return has_entity("Player", opts)
		HAS_COOKING_POT: return has_entity("CookingPot", opts)
		HAS_BLOB: return has_entity("Blob", opts)
		HAS_VOID: return has_entity("Void", opts)

		_: return RoomInputs.new()


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
const IN_TALL_ROOM = "in_tall_room"
const IN_WIDE_ROOM = "in_wide_room"
const IN_T_ROOM = "in_T_room"
const IN_L_ROOM = "in_L_room"
const CUSTOM_ROOM = "in_custom_room"

static func large_room_shape(_opts={}):
	return RoomInputs.new({
		room_shape=[all_room_shapes._4x, all_room_shapes._4x_wide].pick_random(),
		})

static func small_room_shape(_opts={}):
	return RoomInputs.new({
		room_shape=all_room_shapes.small,
		})

static func tall_room_shape(_opts={}):
	return RoomInputs.new({
		room_shape=[all_room_shapes.tall, all_room_shapes.tall_3].pick_random(),
		})

static func wide_room_shape(_opts={}):
	return RoomInputs.new({
		room_shape=[
			all_room_shapes.wide,
			all_room_shapes.wide_3,
			all_room_shapes.wide_4,
			].pick_random(),
		})

static func custom_room_shape(opts={}):
	if opts.get("shape") == null:
		Log.warn("Custom Room shape missing 'shape'!")
	return RoomInputs.new({
		room_shape=opts.get("shape")
		})

static func L_room_shape(_opts={}):
	return RoomInputs.new({
		room_shape=[
			all_room_shapes.L_shape,
			all_room_shapes.L_backwards_shape,
			all_room_shapes.r_shape,
			all_room_shapes.r_backwards_shape,
			].pick_random()
		})

static func T_room_shape(_opts={}):
	return RoomInputs.new({
		room_shape=[
			all_room_shapes.T_shape,
			all_room_shapes.T_inverted_shape,
			all_room_shapes.half_H_shape,
			all_room_shapes.half_H_backwards_shape,
			].pick_random()
		})

## tilemaps ######################################################33

const IN_WOODEN_BOXES = "on_wooden_boxes"
const IN_SPACESHIP = "in_spaceship"
const IN_KINGDOM = "in_kingdom"
const IN_VOLCANO = "in_volcano"
const IN_GRASSY_CAVE = "in_grassy_cave"

static func wooden_boxes(_opts={}):
	return RoomInputs.new({
		tilemap_scenes=["res://addons/core/reptile/tilemaps/WoodenBoxesTiles8.tscn",],
		})

static func spaceship(_opts={}):
	return RoomInputs.new({
		tilemap_scenes=["res://addons/core/reptile/tilemaps/SpaceshipTiles8.tscn",],
		})

static func kingdom(_opts={}):
	return RoomInputs.new({
		tilemap_scenes=["res://addons/core/reptile/tilemaps/GildedKingdomTiles8.tscn",],
		})

static func volcano(_opts={}):
	return RoomInputs.new({
		tilemap_scenes=["res://addons/core/reptile/tilemaps/VolcanoTiles8.tscn",],
		})

static func grassy_cave(_opts={}):
	return RoomInputs.new({
		tilemap_scenes=["res://addons/core/reptile/tilemaps/GrassyCaveTileMap8.tscn",],
		})

## entities ######################################################33

const HAS_BOSS = "has_boss"
const HAS_ENEMY = "has_enemy"
const HAS_TARGET = "has_target"
const HAS_LEAF = "has_leaf"
const HAS_COOKING_POT = "has_cooking_pot"
const HAS_BLOB = "has_blob"
const HAS_VOID = "has_void"
const HAS_PLAYER = "has_player"
const HAS_CANDLE = "has_candle"
const HAS_CHECKPOINT = "has_checkpoint"

static func has_entity(ent, opts={}):
	var inp = RoomInputs.new({entities=U.repeat(ent, opts.get("count", 1))})
	return inp

static func has_boss(opts={}):
	if opts.get("count", 1):
		return RoomInputs.new({
			entities=[["Monstroar"], ["Beefstronaut"]].pick_random(),
			})
	else:
		return RoomInputs.new({
			entities=["Monstroar", "Beefstronaut"],
			})

## encounters ######################################################33

const IS_COOKING_ROOM = "is_cooking_room"

static func cooking_room(_opts={}):
	return RoomInputs.new({
		entities=["Blob", "CookingPot", "Void"],
		})
