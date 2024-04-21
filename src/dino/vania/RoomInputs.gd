extends RefCounted
class_name RoomInputs

# TODO support one way platforms, spikes via grid/tiles
# static var all_entities = [
# 	"OneWayPlatform",
# 	"Spikes",
# 	]

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

# TODO more like toggle-able constraints?
static var all_constraints = [
	# room shapes are not editable
	# IN_LARGE_ROOM,
	# IN_SMALL_ROOM,
	# IN_TALL_ROOM,
	# IN_WIDE_ROOM,
	# IN_T_ROOM,
	# IN_L_ROOM,
	# CUSTOM_ROOM,

	HAS_ENEMY,
	HAS_ENTITY,
	HAS_TILES,
	HAS_ROOM,
	HAS_EFFECTS,

	IN_WOODEN_BOXES,
	IN_SPACESHIP,
	IN_KINGDOM,
	IN_VOLCANO,
	IN_GRASSY_CAVE,

	HAS_BOSS,
	HAS_MONSTROAR,
	HAS_BEEFSTRONAUT,

	HAS_BLOB,
	HAS_ROBOT,
	HAS_CRAWLY,
	HAS_SOLDIER,

	HAS_LEAF,

	HAS_ARCADE_MACHINE,
	HAS_BOX,
	HAS_TREASURE_BOX,
	HAS_CANDLE,

	HAS_CHECKPOINT,
	HAS_LOG_CHECKPOINT,
	HAS_SNOW_CHECKPOINT,
	HAS_CAVE_CHECKPOINT,
	HAS_COOKING_POT,
	HAS_TARGET,
	HAS_VOID,

	HAS_PLAYER,

	IS_COOKING_ROOM,
	]

var entities
var enemies
var room_shape
var room_shapes
var room_effects
var tilemap_scenes

# TODO support props, backgrounds

func _init(opts={}):
	entities = opts.get("entities", [])
	enemies = opts.get("enemies", [])
	room_shape = opts.get("room_shape")
	room_shapes = opts.get("room_shapes", [])
	room_effects = opts.get("room_effects", [])
	tilemap_scenes = opts.get("tilemap_scenes", [])

func to_printable():
	return {
		entities=entities,
		enemies=enemies,
		tilemap_scenes=tilemap_scenes,
		room_shape=room_shape,
		room_shapes=room_shapes,
		room_effects=room_effects,
		}

## merge ######################################################

func merge(b: RoomInputs):
	return RoomInputs.new({
		entities=U.append_array(entities, b.entities),
		enemies=U.append_array(enemies, b.enemies),
		room_shape=U._or(b.room_shape, room_shape),
		room_shapes=U.distinct(U.append_array(room_shapes, b.room_shapes)),
		room_effects=U.distinct(U.append_array(room_effects, b.room_effects)),
		tilemap_scenes=U.distinct(U.append_array(tilemap_scenes, b.tilemap_scenes)),
		})

func merge_constraint(b):
	return RoomInputs.apply_constraint(self, b)

## update room def ######################################################

func update_def(def: VaniaRoomDef):
	if room_shape:
		def.set_local_cells(room_shape)
	elif not room_shapes.is_empty():
		def.set_local_cells(room_shapes.pick_random())
	else:
		def.set_local_cells(all_room_shapes.values().pick_random())

	if not room_effects.is_empty():
		def.effects = room_effects

	if not entities.is_empty():
		def.entities = entities

	if not enemies.is_empty():
		def.enemies = enemies

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

		# generic
		HAS_ENTITY: return has_entity(null, opts)
		HAS_ENEMY: return has_enemy(null, opts)
		HAS_TILES: return has_tiles(opts)
		HAS_ROOM: return custom_room_shape(opts)
		HAS_EFFECTS: return has_effects(opts)

		# tiles
		IN_WOODEN_BOXES: return wooden_boxes(opts)
		IN_SPACESHIP: return spaceship(opts)
		IN_KINGDOM: return kingdom(opts)
		IN_VOLCANO: return volcano(opts)
		IN_GRASSY_CAVE: return grassy_cave(opts)

		# enemies
		HAS_BOSS: return has_boss(opts)
		HAS_MONSTROAR: return has_enemy(EnemyIds.MONSTROAR, opts)
		HAS_BEEFSTRONAUT: return has_enemy(EnemyIds.BEEFSTRONAUT, opts)
		HAS_BLOB: return has_enemy(EnemyIds.BLOB, opts)
		HAS_ROBOT: return has_enemy(EnemyIds.ROBOT, opts)
		HAS_CRAWLY: return has_enemy(EnemyIds.SHOOTYCRAWLY, opts)
		HAS_SOLDIER: return has_enemy(EnemyIds.SOLDIER, opts)

		# combinations
		IS_COOKING_ROOM: return cooking_room(opts)

		# pickups/drops
		HAS_LEAF: return has_entity(DinoEntityIds.LEAF, opts)

		HAS_ARCADE_MACHINE: return has_entity(DinoEntityIds.ARCADEMACHINE, opts)
		HAS_BOX: return has_entity(DinoEntityIds.BOX, opts)
		HAS_TREASURE_BOX: return has_entity(DinoEntityIds.TREASURECHEST, opts)
		HAS_COOKING_POT: return has_entity(DinoEntityIds.COOKINGPOT, opts)
		HAS_TARGET: return has_entity(DinoEntityIds.TARGET, opts)
		HAS_VOID: return has_entity(DinoEntityIds.VOID, opts)

		# checkpoints
		HAS_CANDLE: return has_entity(DinoEntityIds.CANDLE, opts)
		HAS_CHECKPOINT: return has_entity(DinoEntityIds.CANDLE, opts)
		HAS_LOG_CHECKPOINT: return has_entity(DinoEntityIds.LOGBENCH, opts)
		HAS_SNOW_CHECKPOINT: return has_entity(DinoEntityIds.SNOWBENCH, opts)
		HAS_CAVE_CHECKPOINT: return has_entity(DinoEntityIds.CAVEBENCH, opts)

		HAS_PLAYER: return has_entity(DinoEntityIds.PLAYERSPAWNPOINT, opts)

		_:
			Log.warn("No constraint found for cons", cons_key)
			return RoomInputs.new()


## room components ######################################################33

static func random_enemies(opts={}):
	return RoomInputs.new({
		enemies=U.rand_of(opts.get("enemy_entities", DinoEnemy.all_enemies()), U.rand_of([0,1,2,3]), true)
		})

static func random_entities(opts={}):
	return RoomInputs.new({
		entities=U.rand_of(opts.get("entities", DinoEntity.all_entities()), U.rand_of([2,3,4]))
		})

static func random_room_shapes(opts={}):
	return RoomInputs.new({
		room_shapes=opts.get("room_shapes", all_room_shapes.values()),
		})

static func random_tilemaps(opts={}):
	return RoomInputs.new({
		tilemap_scenes=[
			opts.get("tilemaps", all_tilemap_scenes).pick_random(),
			opts.get("tilemaps", all_tilemap_scenes).pick_random(),
			]})

static func random_room(opts={}):
	return merge_many([random_enemies(opts), random_entities(opts), random_room_shapes(opts), random_tilemaps(opts)])

## room effects ######################################################33

const HAS_EFFECTS = "has_effects"

static func has_effects(opts):
	return RoomInputs.new({
		room_effects=opts.get("effects")
		})

## room size ######################################################33

const IN_LARGE_ROOM = "in_large_room"
const IN_SMALL_ROOM = "in_small_room"
const IN_TALL_ROOM = "in_tall_room"
const IN_WIDE_ROOM = "in_wide_room"
const IN_T_ROOM = "in_T_room"
const IN_L_ROOM = "in_L_room"
const CUSTOM_ROOM = "in_custom_room"
const HAS_ROOM = "in_custom_room"

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

const HAS_TILES = "has_tiles"

static func has_tiles(opts):
	var tmap_scenes = opts.get("tilemap_scenes")
	if tmap_scenes == null:
		Log.warn("No tilemaps_scenes passed to tile constraint", opts)
	return RoomInputs.new({tilemap_scenes=tmap_scenes})

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

## enemies ######################################################33

const HAS_ENEMY = "has_enemy"

const HAS_BOSS = "has_boss"
const HAS_MONSTROAR = "has_monstroar"
const HAS_BEEFSTRONAUT = "has_beefstronaut"

const HAS_BLOB = "has_blob"
const HAS_ROBOT = "has_robot"
const HAS_CRAWLY = "has_crawly"
const HAS_SOLDIER = "has_solider"

# TODO support more options, e.g. a passed entity (vs ent_id)
static func has_enemy(ent_id, opts={}):
	if ent_id == null:
		ent_id = opts.get("entity_id")
	if ent_id == null:
		Log.warn("No entity_id specified by constraint!", ent_id, opts)
		# TODO select random ent?
		return

	var ent = Pandora.get_entity(ent_id)
	if ent == null:
		Log.warn("No entity for id", ent_id)
		return
	var inp = RoomInputs.new({enemies=U.repeat(ent, opts.get("count", 1))})
	return inp

static func has_boss(opts={}):
	if opts.get("count", 1):
		return RoomInputs.new({
			enemies=[
				[Pandora.get_entity(EnemyIds.MONSTROAR)],
				[Pandora.get_entity(EnemyIds.BEEFSTRONAUT)]
				].pick_random(),
			})
	else:
		return RoomInputs.new({
			enemies=[
				Pandora.get_entity(EnemyIds.MONSTROAR),
				Pandora.get_entity(EnemyIds.BEEFSTRONAUT),
				],
			})

## entities ######################################################33

const HAS_ENTITY = "has_entity"

const HAS_LEAF = "has_leaf"

const HAS_ARCADE_MACHINE = "has_arcade_machine"
const HAS_BOX = "has_box"
const HAS_TREASURE_BOX = "has_treasure_box"

const HAS_CHECKPOINT = "has_checkpoint"
const HAS_LOG_CHECKPOINT = "has_log_checkpoint"
const HAS_SNOW_CHECKPOINT = "has_snow_checkpoint"
const HAS_CAVE_CHECKPOINT = "has_cave_checkpoint"
const HAS_CANDLE = "has_candle"

const HAS_COOKING_POT = "has_cooking_pot"
const HAS_TARGET = "has_target"
const HAS_VOID = "has_void"

const HAS_PLAYER = "has_player"

# TODO support more options, e.g. a passed entity (vs ent_id)
static func has_entity(ent_id, opts={}):
	if ent_id == null:
		ent_id = opts.get("entity_id")
	if ent_id == null:
		Log.warn("No entity_id specified by constraint!", ent_id, opts)
		return

	var ent = Pandora.get_entity(ent_id)
	if ent == null:
		Log.warn("No entity for id", ent_id)
		return
	var inp = RoomInputs.new({entities=U.repeat(ent, opts.get("count", 1))})
	return inp

## encounters ######################################################33

const IS_COOKING_ROOM = "is_cooking_room"

static func cooking_room(_opts={}):
	return RoomInputs.new({
		entities=["CookingPot", "Void"],
		enemies=[Pandora.get_entity(EnemyIds.BLOB)],
		})
