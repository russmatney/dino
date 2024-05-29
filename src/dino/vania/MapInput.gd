extends Resource
class_name MapInput

# TODO support props, backgrounds
# TODO support one way platforms, spikes via grid/tiles
# static var all_entities = [
# 	"OneWayPlatform",
# 	"Spikes",
# 	]

@export var genre_type: DinoData.GenreType
@export var entities: Array[DinoEntity]
@export var enemies: Array[DinoEnemy]

@export var room_shapes: Array[RoomShape]

@export var room_effects: Array[RoomEffect]
@export var tiles: Array[DinoTiles]

@export var door_mode: VaniaRoomDef.DOOR_MODE
@export var neighbor_direction: Vector2i
@export var skip_borders: Array[Vector2i]
@export var drops: Array[DropData]
@export var bg_color: Color

# VaniaRoomDef.to_defs() helpers
# used for creating more rooms with the same MapInput data
@export var dupe_room_count: int = 0
# skip merging the parent mapDef's MapInput into this one
@export var skip_merge: bool = false

var grid: GridDef
var grids: Array[GridDef]

@export_file var grids_path: String :
	set(p):
		grids_path = p
		if p:
			var parsed = GridParser.parse({defs_path=p})
			if parsed:
				grids = parsed.grids
			else:
				Log.warn("failed to parse grids_path", p)

func _init(opts={}):
	if opts.get("genre_type"):
		genre_type = opts.get("genre_type")
	entities.assign(opts.get("entities", []))
	enemies.assign(opts.get("enemies", []))
	room_shapes.assign(opts.get("room_shapes", []))
	if opts.get("room_effects"):
		room_effects.assign(opts.get("room_effects"))
	tiles.assign(opts.get("tiles", []))
	door_mode = opts.get("door_mode", 0)
	neighbor_direction = opts.get("neighbor_direction", Vector2i.ZERO)
	skip_borders.assign(opts.get("skip_borders", []))
	drops.assign(opts.get("drops", []))
	if opts.get("bg_color"):
		bg_color = opts.get("bg_color")

func to_pretty():
	return {
		genre_type=genre_type,
		entities=entities,
		enemies=enemies,
		tiles=tiles,
		room_shapes=room_shapes,
		room_effects=room_effects,
		door_mode=door_mode,
		neighbor_direction=neighbor_direction,
		skip_borders=skip_borders,
		drops=drops,
		}

## merge ######################################################

func merge(b: MapInput):
	if not b:
		return self

	# enums as ints are such a PITA
	var dm = door_mode
	if b.door_mode > 0:
		dm = b.door_mode

	var nbr_dir = neighbor_direction
	if b.neighbor_direction != Vector2i.ZERO:
		nbr_dir = b.neighbor_direction

	return MapInput.new({
		genre_type=U._or(b.genre_type, genre_type),
		entities=U.append_array(entities, b.entities),
		enemies=U.append_array(enemies, b.enemies),
		room_shapes=U.distinct(U.append_array(room_shapes, b.room_shapes)),
		room_effects=U.distinct(U.append_array(room_effects, b.room_effects)),
		tiles=U.distinct(U.append_array(tiles, b.tiles)),
		door_mode=dm,
		neighbor_direction=nbr_dir,
		skip_borders=U.distinct(U.append_array(skip_borders, b.skip_borders)),
		drops=U.distinct(U.append_array(drops, b.drops)),
		bg_color=U._or(b.bg_color, bg_color),
		})

## update room def ######################################################

func update_def(def: VaniaRoomDef):
	def.input = self

	set_room_def_shape(def)

	if tiles.is_empty():
		tiles.assign([DinoTiles.all_tiles().pick_random()])

# should room_def shape or grids overwrite?
func set_room_def_shape(def):
	# TODO figure out local_cells to cover a room from grid-defs
	# TODO flags on grid for borders, fill-space, centering, doors, etc
	# maybe all handled via the new RoomShape class?
	if grid:
		pass
	elif not grids.is_empty():
		pass

	if room_shapes and not room_shapes.is_empty():
		def.set_local_cells(room_shapes.pick_random().cells)
	else:
		def.set_local_cells(RoomShape.random_shape().cells)

################################################################
## static ######################################################

static func merge_many(inputs):
	return inputs.reduce(func(a, b): return a.merge(b))

## apply ######################################################33
# not too sure how necessary apply + update_def are anymore

# updates the passed room def with the passed room input
# maintains the existing def's local_cells (useful for keeping
# the current room shape when regening others)
static func apply(input: MapInput, def: VaniaRoomDef):
	var existing_shape = def.local_cells

	if not input is MapInput:
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
	return MapInput.new({
		enemies=U.rand_of(opts.get("enemy_entities", DinoEnemy.all_enemies()), U.rand_of([0,1,2,3]), true)
		})

static func random_entities(opts={}):
	return MapInput.new({
		entities=U.rand_of(opts.get("entities", DinoEntity.all_entities()), U.rand_of([2,3,4]))
		})

static func random_tiles(_opts={}):
	return MapInput.new({
		tiles=[DinoTiles.all_tiles().pick_random()]})

static func random_effects(_opts={}):
	return MapInput.new({
		room_effects=U.rand_of([
			RoomEffect.random_effect(),
			RoomEffect.random_effect(),
			RoomEffect.random_effect(),
			], U.rand_of([1, 2]))})

static func random_room(opts={}):
	return merge_many([
		random_enemies(opts), random_entities(opts),
		random_tiles(opts), random_effects(opts),
		])

## genre type ######################################################33

static func has_genre(opts):
	if opts.get("genre_type"):
		return MapInput.new({genre_type=opts.get("genre_type"),})

static func sidescroller():
	return MapInput.new({genre_type=DinoData.GenreType.SideScroller})

static func topdown():
	return MapInput.new({genre_type=DinoData.GenreType.TopDown})

static func beatemup():
	return MapInput.new({genre_type=DinoData.GenreType.BeatEmUp})

## room effects ######################################################33

static func has_effects(opts):
	if opts.get("effects"):
		return MapInput.new({room_effects=opts.get("effects")})
	return MapInput.random_effects()

static func has_rain_fall(_opts={}):
	return MapInput.new({room_effects=[RoomEffect.rain_fall()]})

static func has_snow_fall(_opts={}):
	return MapInput.new({room_effects=[RoomEffect.snow_fall()]})

static func has_dust(_opts={}):
	return MapInput.new({room_effects=[RoomEffect.dust()]})

## room size ######################################################33

static func has_room(opts={}):
	if not opts.get("shape") == null:
		return MapInput.new({room_shapes=[opts.get("shape")]})
	if not opts.get("cells") == null:
		return MapInput.new({room_shapes=[RoomShape.new({cells=opts.get("cells")})]})

static func small_room_shape(_opts={}):
	return MapInput.new({room_shapes=[RoomShape.small_room()]})

static func large_room_shape(_opts={}):
	return MapInput.new({room_shapes=[RoomShape.large_rooms().pick_random()]})

static func tall_room_shape(_opts={}):
	return MapInput.new({room_shapes=[RoomShape.tall_rooms().pick_random()]})

static func wide_room_shape(_opts={}):
	return MapInput.new({room_shapes=[RoomShape.wide_rooms().pick_random()]})

static func L_room_shape(_opts={}):
	return MapInput.new({room_shapes=[RoomShape.L_rooms().pick_random()]})

static func T_room_shape(_opts={}):
	return MapInput.new({room_shapes=[RoomShape.T_rooms().pick_random()]})

## tilemaps ######################################################33

static func has_tiles(opts):
	var ts = []
	for id in opts.get("tile_ids", []):
		ts.append(Pandora.get_entity(id))
	ts.append_array(opts.get("tiles", []))

	return MapInput.new({tiles=ts})

static func coldfire_tiles(_opts={}):
	return MapInput.new({tiles=[
		Pandora.get_entity(DinoTileIds.COLDFIRETILES)]})

static func wooden_boxes(_opts={}):
	return MapInput.new({tiles=[
		Pandora.get_entity(DinoTileIds.WOODENBOXTILES)]})

static func spaceship(_opts={}):
	return MapInput.new({tiles=[
		Pandora.get_entity(DinoTileIds.SPACESHIPTILES)]})

static func kingdom(_opts={}):
	return MapInput.new({tiles=[
		Pandora.get_entity(DinoTileIds.KINGDOMTILES)]})

static func volcano(_opts={}):
	return MapInput.new({tiles=[
		Pandora.get_entity(DinoTileIds.VOLCANOTILES)]})

static func grassy_cave(_opts={}):
	return MapInput.new({tiles=[
		Pandora.get_entity(DinoTileIds.GRASSYCAVETILES)]})

## with ######################################################33

static func with(opts={}):
	var ents = []
	for id in opts.get("entity_ids", []):
		ents.append(Pandora.get_entity(id))
	ents.append_array(opts.get("entities", []))

	var ens = []
	for id in opts.get("enemy_ids", []):
		ens.append(Pandora.get_entity(id))
	ens.append_array(opts.get("enemies", []))

	var effs = opts.get("effects", [])

	var ts = []
	for id in opts.get("tile_ids", []):
		ts.append(Pandora.get_entity(id))
	ts.append_array(opts.get("tiles", []))

	return MapInput.new({entities=ents, enemies=ens, effects=effs,
		tiles=ts})

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
	var inp = MapInput.new({enemies=U.repeat(ent, opts.get("count", 1))})
	return inp

static func has_boss(opts={}):
	if opts.get("count", 1):
		return MapInput.new({
			enemies=[
				[Pandora.get_entity(EnemyIds.MONSTROAR)],
				[Pandora.get_entity(EnemyIds.BEEFSTRONAUT)]
				].pick_random(),
			})
	else:
		return MapInput.new({
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
	var inp = MapInput.new({entities=U.repeat(ent, opts.get("count", 1))})
	return inp

static func has_entities(opts={}):
	var ents = []
	for ent_id in opts.get("entity_ids"):
		ents.append(Pandora.get_entity(ent_id))
	ents.append_array(opts.get("entities", []))
	return MapInput.new({entities=ents})

static func has_player(opts={}):
	return has_entity(DinoEntityIds.PLAYERSPAWNPOINT, opts)
