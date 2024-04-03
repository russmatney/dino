@tool
extends RefCounted
class_name VaniaRoomDef

const vania_room_path = "res://src/dino/modes/vania/maps/VaniaRoom.tscn"
const vania_room_path_wide = "res://src/dino/modes/vania/maps/VaniaRoomWide.tscn"
const vania_room_path_tall = "res://src/dino/modes/vania/maps/VaniaRoomTall.tscn"
const vania_room_path_4x = "res://src/dino/modes/vania/maps/VaniaRoom4x.tscn"

var room_type: DinoData.RoomType = DinoData.RoomType.SideScroller
var base_scene_path: String
var room_scene: PackedScene
var room_path: String

var local_cells: Array #[Vector3i]
var map_cells: Array #[Vector3i]

var min_map_cell := Vector2i.MAX
var max_map_cell := Vector2i.MIN

var bg_color: Color = Color.BLACK
var border_color: Color = Color.WHITE

var index: int

var tile_defs: GridDefs
var entity_defs: GridDefs
var entities: Array #[String]

var tilemap_scene
var tile_size: int = 16

# TODO support pandora entities instead of scenes directly?
var label_to_entity = {
	# player
	"Player": {scene=load("res://addons/core/PlayerSpawnPoint.tscn")},

	# bosses
	"Monstroar": {scene=load("res://src/hatbot/bosses/Monstroar.tscn")},
	"Beefstronaut": {scene=load("res://src/hatbot/bosses/Beefstronaut.tscn")},

	# enemies
	"Blob": {scene=load("res://src/spike/enemies/Blob.tscn")},
	"Enemy": {scene=load("res://src/gunner/enemies/EnemyRobot.tscn")},

	# pickups
	"Leaf": {scene=load("res://src/woods/entities/Leaf.tscn")},

	# entities
	"Candle": {scene=load("res://src/hatbot/entities/Candle.tscn")},
	"CookingPot": {scene=load("res://src/spike/entities/CookingPot.tscn"),
		setup=func(p, opts): p.position += Vector2(opts.tile_size/2.0, opts.tile_size)
		},
	"Target": {scene=load("res://src/gunner/targets/Target.tscn"),
		setup=func(t, opts):
		t.position += Vector2.RIGHT * opts.tile_size / 2.0
		t.position += Vector2.DOWN * opts.tile_size / 2.0
		},
	"Void": {scene=load("res://src/spike/entities/DeliveryZone.tscn")},

	# platforms/walls
	"OneWayPlatform": {scene=load("res://src/spike/zones/OneWayPlatform.tscn"),
		# resize to match tile_size
		setup=func(p, opts):
		p.max_width = opts.tile_size
		p.position.x += opts.tile_size/2.0
		p.position.y += opts.tile_size/4.0
		},
	}

var skip_entities = ["CookingPot", "Void", "Player"]
var all_entities = []

var all_tilemap_scenes = [
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

func to_printable():
	return {
		entities=entities,
		room_path=room_path.get_file(),
		local_cells=local_cells,
		}

## init #####################################################3

func _init(opts={}):
	all_entities = label_to_entity.keys().filter(func(x): return not x in skip_entities)

	room_type = opts.get("room_type", room_type)
	if opts.get("base_scene_path"):
		base_scene_path = opts.get("base_scene_path")
	# TODO create this dynamically - does it really need to be represented in the main map?
	room_scene = opts.get("room_scene")
	local_cells = opts.get("local_cells", [])

	bg_color = opts.get("bg_color", bg_color)
	border_color = opts.get("border_color", border_color)

	tile_defs = opts.get("tile_defs")
	entity_defs = opts.get("entity_defs")
	if opts.get("entities"):
		entities = opts.get("entities")
		Log.pr("setting entities", entities)
	tile_size = opts.get("tile_size", tile_size)

## setters #####################################################3

func set_room_type(t: DinoData.RoomType) -> VaniaRoomDef:
	self.room_type = t
	return self

func set_base_scene(path) -> VaniaRoomDef:
	self.base_scene_path = path
	return self

func add_entities(ents: Array) -> VaniaRoomDef:
	self.entities = ents
	return self

func calc_cell_meta():
	for p in map_cells:
		min_map_cell.x = mini(min_map_cell.x, p.x)
		min_map_cell.y = mini(min_map_cell.y, p.y)
		max_map_cell.x = maxi(max_map_cell.x, p.x)
		max_map_cell.y = maxi(max_map_cell.y, p.y)


## random data builders #####################################################3

func select_room_type():
	var types = [DinoData.RoomType.SideScroller, DinoData.RoomType.TopDown]
	self.room_type = types.pick_random()
	return self

func select_room_shape():
	var shapes = [
		[[Vector3i()], vania_room_path],
		[[Vector3i(), Vector3i(1, 0, 0),], vania_room_path,],
		[[Vector3i(), Vector3i(0, 1, 0),], vania_room_path],
		[[Vector3i(0, 0, 0), Vector3i(1, 0, 0),
			Vector3i(0, 1, 0), Vector3i(1, 1, 0),], vania_room_path],
		]
	var shape = shapes.pick_random()
	self.local_cells = shape[0]
	self.base_scene_path = shape[1]
	return self

func select_entities():
	self.entities = U.rand_of(all_entities, U.rand_of([2,3,4]))
	return self

func select_tilemap():
	tilemap_scene = load(all_tilemap_scenes.pick_random())
	return self

## static #####################################################3

static func generate_defs(opts={}):
	var entity_defs_path = "res://src/dino/modes/vania/entities.txt"
	var e_defs = GridParser.parse({defs_path=entity_defs_path})
	var tile_defs_path = "res://src/dino/modes/vania/tiles.txt"
	var t_defs = GridParser.parse({defs_path=tile_defs_path})

	var defs: Array[VaniaRoomDef] = []
	var fixed = [
		{entities=["Candle", "Player", "Target", "Leaf"]}
		]
	for i in range(opts.get("count", 4)):
		var data = {
			entity_defs=e_defs,
			tile_defs=t_defs,
			tile_size=opts.get("tile_size"),}
		if i < len(fixed):
			data.merge(fixed[i])

		var def = VaniaRoomDef.new(data)

		def.select_room_shape()

		if def.entities.is_empty():
			def.select_entities()

		def.select_tilemap()

		def.index = i
		defs.append(def)

	return defs

### misc helpers

func get_local_cells_dict():
	var local = {}
	for coord in local_cells:
		local[coord] = true
	return local

func get_local_width() -> Vector2i:
	return Reptile.get_width(local_cells)

func get_local_height() -> Vector2i:
	return Reptile.get_height(local_cells)

func get_size() -> Vector2:
	return Vector2(max_map_cell - min_map_cell + Vector2i.ONE) * MetSys.settings.in_game_cell_size

func to_local_cell(cell: Vector3i) -> Vector2i:
	return Vector2i(cell.x - min_map_cell.x, cell.y - min_map_cell.y)

func get_cell_rect(cell: Vector2i) -> Rect2:
	return Rect2(Vector2(cell) * MetSys.settings.in_game_cell_size, MetSys.settings.in_game_cell_size)

func get_neighbor_room_paths() -> Array[String]:
	var ret: Array[String] = []

	for cell in map_cells:
		var cell_data: MetroidvaniaSystem.MapData.CellData = MetSys.map_data.get_cell_at(cell)
		assert(cell_data)
		for i in 4:
			var fwd: Vector2i = MetroidvaniaSystem.MapData.FWD[i]
			var nbr_room_path: String = MetSys.map_data.get_assigned_scene_at(cell + Vector3i(fwd.x, fwd.y, 0))
			if not nbr_room_path.is_empty() and nbr_room_path != room_path and not nbr_room_path in ret:
				ret.append(nbr_room_path)

	return ret
