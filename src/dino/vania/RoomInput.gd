extends Resource
class_name RoomInput

# TODO support one way platforms, spikes via grid/tiles
# static var all_entities = [
# 	"OneWayPlatform",
# 	"Spikes",
# 	]
static var all_constraints = []

# TODO support props, backgrounds

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


@export var genre_type: DinoData.GenreType
@export var entities: Array[DinoEntity]
@export var enemies: Array[DinoEnemy]
@export var room_shape: Array[Vector3i]
@export var room_shapes = []
@export var room_effects: Array[RoomEffect]
@export var tilemap_scenes: Array[PackedScene]

func _init(opts={}):
	if opts.get("genre_type"):
		genre_type = opts.get("genre_type")
	if opts.get("entities"):
		entities.assign(opts.get("entities"))
	if opts.get("enemies"):
		enemies.assign(opts.get("enemies"))
	if opts.get("room_shape"):
		room_shape.assign(opts.get("room_shape"))
	room_shapes.assign(opts.get("room_shapes", []))
	if opts.get("room_effects"):
		room_effects.assign(opts.get("room_effects"))
	if opts.get("tilemap_scenes"):
		tilemap_scenes.assign(opts.get("tilemap_scenes"))

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

func merge(b: RoomInput):
	return RoomInput.new({
		genre_type=U._or(b.genre_type, genre_type),
		entities=U.append_array(entities, b.entities),
		enemies=U.append_array(enemies, b.enemies),
		room_shape=U._or(b.room_shape, room_shape),
		room_shapes=U.distinct(U.append_array(room_shapes, b.room_shapes)),
		room_effects=U.distinct(U.append_array(room_effects, b.room_effects)),
		tilemap_scenes=U.distinct(U.append_array(tilemap_scenes, b.tilemap_scenes)),
		})

## update room def ######################################################

func update_def(def: VaniaRoomDef):
	if genre_type != null:
		def.genre_type = genre_type

	if not room_shape.is_empty():
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
		def.tilemap_scenes = [load(all_tilemap_scenes.pick_random())]

################################################################
## static ######################################################

static func merge_many(inputs):
	return inputs.reduce(func(a, b): return a.merge(b))

# updates the passed room def with the passed room input
# maintains the existing def's local_cells
static func apply(input: RoomInput, def: VaniaRoomDef):
	var existing_shape = def.local_cells

	if not input is RoomInput:
		Log.warn("Unhandled input passed to apply, aborting", input)
		return

	def.input = input

	input.update_def(def)

	if existing_shape != null and not existing_shape.is_empty():
		# maintain pre-existing local_cells
		def.set_local_cells(existing_shape)

	return input

## room components ######################################################33

static func random_enemies(opts={}):
	return RoomInput.new({
		enemies=U.rand_of(opts.get("enemy_entities", DinoEnemy.all_enemies()), U.rand_of([0,1,2,3]), true)
		})

static func random_entities(opts={}):
	return RoomInput.new({
		entities=U.rand_of(opts.get("entities", DinoEntity.all_entities()), U.rand_of([2,3,4]))
		})

static func random_room_shapes(opts={}):
	return RoomInput.new({
		room_shapes=opts.get("room_shapes", all_room_shapes.values()),
		})

static func random_tilemaps(_opts={}):
	return RoomInput.new({
		tilemap_scenes=[
			load(all_tilemap_scenes.pick_random()),
			load(all_tilemap_scenes.pick_random()),
			]})

static func random_effects(_opts={}):
	return RoomInput.new({
		room_effects=U.rand_of([
			RoomEffect.random_effect(),
			RoomEffect.random_effect(),
			RoomEffect.random_effect(),
			], U.rand_of([1, 2]))})

static func random_room(opts={}):
	return merge_many([
		random_enemies(opts), random_entities(opts),
		random_room_shapes(opts),
		random_tilemaps(opts), random_effects(opts),
		])

## genre type ######################################################33

static func has_genre(opts):
	if opts.get("genre_type"):
		return RoomInput.new({genre_type=opts.get("genre_type"),})

static func sidescroller():
	return RoomInput.new({genre_type=DinoData.GenreType.SideScroller})

static func topdown():
	return RoomInput.new({genre_type=DinoData.GenreType.TopDown})

static func beatemup():
	return RoomInput.new({genre_type=DinoData.GenreType.BeatEmUp})

## room effects ######################################################33

static func has_effects(opts):
	if opts.get("effects"):
		return RoomInput.new({
			room_effects=opts.get("effects")
			})
	return RoomInput.random_effects()

static func has_rain_fall(_opts={}):
	return RoomInput.new({
		room_effects=[RoomEffect.rain_fall()]
		})

static func has_snow_fall(_opts={}):
	return RoomInput.new({
		room_effects=[RoomEffect.snow_fall()]
		})

static func has_dust(_opts={}):
	return RoomInput.new({
		room_effects=[RoomEffect.dust()]
		})

## room size ######################################################33

static func has_room(opts={}):
	if opts.get("shape") == null:
		Log.warn("has_room missing 'shape'!")
	return RoomInput.new({
		room_shape=opts.get("shape")
		})

static func small_room_shape(_opts={}):
	return RoomInput.new({room_shape=all_room_shapes.small})

static func large_room_shape(_opts={}):
	return RoomInput.new({
		room_shape=[all_room_shapes._4x, all_room_shapes._4x_wide].pick_random(),
		})

static func tall_room_shape(_opts={}):
	return RoomInput.new({
		room_shape=[all_room_shapes.tall, all_room_shapes.tall_3].pick_random(),
		})

static func wide_room_shape(_opts={}):
	return RoomInput.new({
		room_shape=[
			all_room_shapes.wide,
			all_room_shapes.wide_3,
			all_room_shapes.wide_4,
			].pick_random(),
		})

static func L_room_shape(_opts={}):
	return RoomInput.new({
		room_shape=[
			all_room_shapes.L_shape,
			all_room_shapes.L_backwards_shape,
			all_room_shapes.r_shape,
			all_room_shapes.r_backwards_shape,
			].pick_random()
		})

static func T_room_shape(_opts={}):
	return RoomInput.new({
		room_shape=[
			all_room_shapes.T_shape,
			all_room_shapes.T_inverted_shape,
			all_room_shapes.half_H_shape,
			all_room_shapes.half_H_backwards_shape,
			].pick_random()
		})

## tilemaps ######################################################33

static func has_tiles(opts):
	var tmap_scenes = opts.get("tilemap_scenes")
	if tmap_scenes == null:
		Log.warn("No tilemaps_scenes passed to tile constraint", opts)
	return RoomInput.new({tilemap_scenes=tmap_scenes})

static func wooden_boxes(_opts={}):
	return RoomInput.new({
		tilemap_scenes=[
			load("res://addons/core/reptile/tilemaps/WoodenBoxesTiles8.tscn")
			],
		})

static func spaceship(_opts={}):
	return RoomInput.new({
		tilemap_scenes=[
			load("res://addons/core/reptile/tilemaps/SpaceshipTiles8.tscn")
			],
		})

static func kingdom(_opts={}):
	return RoomInput.new({
		tilemap_scenes=[load("res://addons/core/reptile/tilemaps/GildedKingdomTiles8.tscn")],
		})

static func volcano(_opts={}):
	return RoomInput.new({
		tilemap_scenes=[
			load("res://addons/core/reptile/tilemaps/VolcanoTiles8.tscn")],
		})

static func grassy_cave(_opts={}):
	return RoomInput.new({
		tilemap_scenes=[
			load("res://addons/core/reptile/tilemaps/GrassyCaveTileMap8.tscn")],
		})

## with ######################################################33

static func with(opts={}):
	var ents = []
	for ent_id in opts.get("entity_ids", []):
		ents.append(Pandora.get_entity(ent_id))
	ents.append_array(opts.get("entities", []))

	var ens = []
	for ent_id in opts.get("enemy_ids", []):
		ens.append(Pandora.get_entity(ent_id))
	ens.append_array(opts.get("enemies", []))

	var effs = opts.get("effects", [])

	return RoomInput.new({entities=ents, enemies=ens, effects=effs})

## enemies ######################################################33

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
	var inp = RoomInput.new({enemies=U.repeat(ent, opts.get("count", 1))})
	return inp

static func has_boss(opts={}):
	if opts.get("count", 1):
		return RoomInput.new({
			enemies=[
				[Pandora.get_entity(EnemyIds.MONSTROAR)],
				[Pandora.get_entity(EnemyIds.BEEFSTRONAUT)]
				].pick_random(),
			})
	else:
		return RoomInput.new({
			enemies=[
				Pandora.get_entity(EnemyIds.MONSTROAR),
				Pandora.get_entity(EnemyIds.BEEFSTRONAUT),
				],
			})

## entities ######################################################33

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
	var inp = RoomInput.new({entities=U.repeat(ent, opts.get("count", 1))})
	return inp

static func has_entities(opts={}):
	var ents = []
	for ent_id in opts.get("entity_ids"):
		ents.append(Pandora.get_entity(ent_id))
	ents.append_array(opts.get("entities", []))
	return RoomInput.new({entities=ents})

static func has_player(opts={}):
	return has_entity(DinoEntityIds.PLAYERSPAWNPOINT, opts)
