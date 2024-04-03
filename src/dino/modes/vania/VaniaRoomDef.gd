@tool
extends RefCounted
class_name VaniaRoomDef

var base_scene_path = "res://src/dino/modes/vania/maps/VaniaRoom.tscn"

# TODO rename to genre type or machine type?
var room_type: DinoData.RoomType = DinoData.RoomType.SideScroller
var room_path: String

var local_cells: Array #[Vector3i]
var map_cells: Array #[Vector3i]

var min_map_cell := Vector2i.MAX
var max_map_cell := Vector2i.MIN

var bg_color: Color = Color.BLACK
var border_color: Color = Color.WHITE

var tile_defs: GridDefs
var entity_defs: GridDefs
var entities: Array #[String]

var tilemap_scenes
var tile_size

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
		p.max_width = opts.tile_size * 6
		p.position.x += opts.tile_size/2.0
		p.position.y += opts.tile_size/4.0
		},
	}

var all_entities = []

func to_printable():
	return {
		entities=entities,
		room_path=room_path.get_file(),
		local_cells=local_cells,
		}

## init #####################################################3

func _init(opts={}):
	all_entities = label_to_entity.keys()

	room_type = opts.get("room_type", room_type)
	local_cells = opts.get("local_cells", [])

	bg_color = opts.get("bg_color", bg_color)
	border_color = opts.get("border_color", border_color)

	tile_defs = opts.get("tile_defs")
	entity_defs = opts.get("entity_defs")

	tile_size = opts.get("tile_size", tile_size)

## map_cells #####################################################

func calc_cell_meta():
	for p in map_cells:
		min_map_cell.x = mini(min_map_cell.x, p.x)
		min_map_cell.y = mini(min_map_cell.y, p.y)
		max_map_cell.x = maxi(max_map_cell.x, p.x)
		max_map_cell.y = maxi(max_map_cell.y, p.y)

func get_size() -> Vector2:
	if (min_map_cell == Vector2i.MAX or max_map_cell == Vector2i.MIN):
		calc_cell_meta()
	return Vector2(max_map_cell - min_map_cell + Vector2i.ONE) * MetSys.settings.in_game_cell_size

func to_local_cell(cell: Vector3i) -> Vector2i:
	if (min_map_cell == Vector2i.MAX or max_map_cell == Vector2i.MIN):
		calc_cell_meta()
	return Vector2i(cell.x - min_map_cell.x, cell.y - min_map_cell.y)

func get_cell_rect(cell: Vector2i) -> Rect2:
	return Rect2(Vector2(cell) * MetSys.settings.in_game_cell_size, MetSys.settings.in_game_cell_size)

## local_cells ######################################################

func get_local_cells_dict():
	var local = {}
	for coord in local_cells:
		local[coord] = true
	return local

func get_local_width() -> Vector2i:
	return Reptile.get_width(local_cells)

func get_local_height() -> Vector2i:
	return Reptile.get_height(local_cells)

## neighbors ######################################################

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

## static #####################################################3

static func generate_defs(opts={}):
	var entity_defs_path = "res://src/dino/modes/vania/entities.txt"
	var e_defs = GridParser.parse({defs_path=entity_defs_path})
	var tile_defs_path = "res://src/dino/modes/vania/tiles.txt"
	var t_defs = GridParser.parse({defs_path=tile_defs_path})

	var defs: Array[VaniaRoomDef] = []

	var room_inputs = [
		RoomInputs.player_room().merge(RoomInputs.spaceship()),
		RoomInputs.leaf_room().merge(RoomInputs.kingdom()),
		RoomInputs.target_room().merge(RoomInputs.volcano()),
		RoomInputs.enemy_room().merge(RoomInputs.grassy_cave()),
		RoomInputs.merge_many([
			RoomInputs.target_room(), RoomInputs.leaf_room(),
			RoomInputs.wooden_boxes()
			]),
		RoomInputs.boss_room().merge(RoomInputs.spaceship()),
		RoomInputs.random_room(),
		RoomInputs.enemy_room().merge(RoomInputs.random_tilemaps()),
		RoomInputs.cooking_room().merge(RoomInputs.random_tilemaps()),
		RoomInputs.merge_many([
			RoomInputs.target_room(), RoomInputs.target_room(),
			RoomInputs.target_room(), RoomInputs.enemy_room(),
			]).overwrite_room(RoomInputs.large_room()).merge(RoomInputs.random_tilemaps()),
		RoomInputs.boss_room().merge(RoomInputs.volcano()),
		]

	for inputs in room_inputs:
		var def = VaniaRoomDef.new({
			entity_defs=e_defs, tile_defs=t_defs,
			tile_size=opts.get("tile_size")
			})
		inputs.update_def(def)
		defs.append(def)

	return defs

