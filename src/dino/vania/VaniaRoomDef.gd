@tool
extends RefCounted
class_name VaniaRoomDef

var base_scene_path = "res://src/dino/vania/maps/VaniaRoom.tscn"

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
var tile_size = 16

var constraints = []

# TODO support pandora entities instead of scenes directly?
var label_to_entity = {
	# player
	"Player": {scene=load("res://addons/core/PlayerSpawnPoint.tscn")},

	# bosses
	"Monstroar": {scene=load("res://src/dino/entities/bosses/Monstroar.tscn")},
	"Beefstronaut": {scene=load("res://src/dino/entities/bosses/Beefstronaut.tscn")},

	# enemies
	"Blob": {scene=load("res://src/dino/entities/blobs/Blob.tscn")},
	"EnemyRobot": {scene=load("res://src/dino/entities/enemyRobots/EnemyRobot.tscn")},
	"Glowmba": {scene=load("res://src/dino/entities/glowmba/Glowmba.tscn")},

	# pickups
	"Leaf": {scene=load("res://src/dino/entities/leaves/Leaf.tscn")},

	# entities
	"Checkpoint": {scene=load("res://src/dino/entities/checkpoints/SnowCheckpoint.tscn")},
	"LogCheckpoint": {scene=load("res://src/dino/entities/checkpoints/LogCheckpoint.tscn")},
	"SnowCheckpoint": {scene=load("res://src/dino/entities/checkpoints/SnowCheckpoint.tscn")},
	"CaveCheckpoint": {scene=load("res://src/dino/entities/checkpoints/CaveCheckpoint.tscn")},
	"Candle": {scene=load("res://src/dino/entities/checkpoints/Candle.tscn")},
	"CookingPot": {scene=load("res://src/dino/entities/cookingPot/CookingPot.tscn"),
		setup=func(p, opts): p.position += Vector2(opts.tile_size/2.0, opts.tile_size)
		},
	"Target": {scene=load("res://src/dino/entities/targets/Target.tscn"),
		setup=func(t, opts):
		t.position += Vector2.RIGHT * opts.tile_size / 2.0
		t.position += Vector2.DOWN * opts.tile_size / 2.0
		},
	"Void": {scene=load("res://src/dino/entities/void/DeliveryZone.tscn")},

	# platforms/walls
	"OneWayPlatform": {scene=load("res://src/dino/platforms/OneWayPlatform.tscn"),
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
		map_cells=map_cells,
		}

## init #####################################################3

func _init(opts={}):
	all_entities = label_to_entity.keys()

	room_type = opts.get("room_type", room_type)
	if opts.get("local_cells"):
		set_local_cells(opts.get("local_cells"))

	bg_color = opts.get("bg_color", bg_color)
	border_color = opts.get("border_color", border_color)

	tile_defs = opts.get("tile_defs")
	entity_defs = opts.get("entity_defs")

	tile_size = U.get_(opts, "tile_size", tile_size)

	if opts.get("room_inputs"):
		constraints = opts.get("room_inputs")
	elif opts.get("constraints"):
		constraints = opts.get("constraints")

	if constraints != null:
		if constraints is Array and constraints.is_empty():
			return
		RoomInputs.apply_constraints(constraints, self)

func set_local_cells(cells):
	var min_cell := Vector3i(Vector2i.MAX.x, Vector2i.MAX.y, 0)
	for c in cells:
		min_cell.x = mini(min_cell.x, c.x)
		min_cell.y = mini(min_cell.y, c.y)

	local_cells = []
	for c in cells:
		local_cells.append(c - min_cell)

## tilemap helpers #####################################################

func get_primary_tilemap():
	if tilemap_scenes.is_empty():
		Log.warn("No tilemap_scenes on room_def, cannot return primary tilemap")
		return
	else:
		return tilemap_scenes[0]

func get_secondary_tilemap():
	if tilemap_scenes.is_empty():
		Log.warn("No tilemap_scenes on room_def, cannot return secondary tilemap")
		return
	else:
		if len(tilemap_scenes) > 1:
			return tilemap_scenes[1]
		else:
			return tilemap_scenes[0]

## map_cells #####################################################

func calc_cell_meta():
	for p in map_cells:
		min_map_cell.x = mini(min_map_cell.x, p.x)
		min_map_cell.y = mini(min_map_cell.y, p.y)
		max_map_cell.x = maxi(max_map_cell.x, p.x)
		max_map_cell.y = maxi(max_map_cell.y, p.y)

# the size of the entire room in pixels
func get_size() -> Vector2:
	if (min_map_cell == Vector2i.MAX or max_map_cell == Vector2i.MIN):
		calc_cell_meta()
	return Vector2(max_map_cell - min_map_cell + Vector2i.ONE) * MetSys.settings.in_game_cell_size

func get_rect() -> Rect2:
	return Rect2(Vector2(), get_size())

func map_cell_to_local_cell(cell: Vector3i) -> Vector2i:
	if (min_map_cell == Vector2i.MAX or max_map_cell == Vector2i.MIN):
		calc_cell_meta()
	return Vector2i(cell.x - min_map_cell.x, cell.y - min_map_cell.y)

func get_local_rect(cell: Vector2i) -> Rect2:
	return Rect2(Vector2(cell) * MetSys.settings.in_game_cell_size,
		MetSys.settings.in_game_cell_size)

# returns a local rect (position/size) of a rect around the passed map_cell coord
func get_map_cell_rect(map_cell: Vector3i) -> Rect2:
	return get_local_rect(map_cell_to_local_cell(map_cell))

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

func get_doors(opts={}):
	var neighbors = build_neighbor_data(opts)
	var doors = []
	for n in neighbors:
		doors.append_array(n.possible_doors)
	return doors

func build_neighbor_data(opts={}):
	var neighbors = opts.get("neighbor_data", [])
	if neighbors.is_empty():
		var neighbor_paths = get_neighbor_room_paths()
		for p in neighbor_paths:
			neighbors.append({room_path=p, map_cells=MetSys.map_data.get_cells_assigned_to(p)})

	for ngbr in neighbors:
		if ngbr.get("possible_doors"): # maybe already calced?
			continue
		ngbr.possible_doors = []
		for n_cell in ngbr.map_cells:
			for r_cell in map_cells:
				if is_neighboring_cell(n_cell, r_cell):
					ngbr.possible_doors.append([r_cell, n_cell])

	return neighbors

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

func is_neighboring_cell(a: Vector3i, b: Vector3i) -> bool:
	if a.x - b.x == 0:
		return abs(a.y - b.y) == 1
	if a.y - b.y == 0:
		return abs(a.x - b.x) == 1
	return false

## constraints #####################################################3

func reapply_constraints():
	RoomInputs.apply_constraints(constraints, self)

## static #####################################################3

static func generate_defs(opts={}) -> Array[VaniaRoomDef]:
	var entity_defs_path = "res://src/dino/vania/entities.txt"
	var e_defs = GridParser.parse({defs_path=entity_defs_path})
	var tile_defs_path = "res://src/dino/vania/tiles.txt"
	var t_defs = GridParser.parse({defs_path=tile_defs_path})

	var defs: Array[VaniaRoomDef] = []

	var room_inputs = opts.get("room_inputs", [])

	if room_inputs.is_empty():
		room_inputs = [
			[
				RoomInputs.HAS_PLAYER,
				RoomInputs.HAS_CANDLE,
				RoomInputs.IN_SPACESHIP,
				RoomInputs.IN_SMALL_ROOM,
			], [
				{RoomInputs.HAS_LEAF: {count=2}},
				RoomInputs.IN_GRASSY_CAVE,
				RoomInputs.IN_WIDE_ROOM,
			], {
				RoomInputs.HAS_TARGET: {count=3},
				RoomInputs.IN_VOLCANO: {}
			},
			# [
			# 	{RoomInputs.HAS_ENEMY_ROBOT: {count=3}},
			# 	RoomInputs.IN_LARGE_ROOM,
			# ], [
			# 	RoomInputs.HAS_TARGET,
			# 	RoomInputs.HAS_LEAF,
			# 	RoomInputs.IN_WOODEN_BOXES,
			# ], [
			# 	RoomInputs.HAS_BOSS,
			# 	RoomInputs.IN_LARGE_ROOM,
			# 	RoomInputs.IN_SPACESHIP,
			# ],
			# 	RoomInputs.random_room(),
			# {
			# 	RoomInputs.HAS_ENEMY_ROBOT: {count=3},
			# }, [
			# 	RoomInputs.IS_COOKING_ROOM,
			# ], {
			# 	RoomInputs.HAS_TARGET: {count=5},
			# 	RoomInputs.HAS_ENEMY_ROBOT: {count=2},
			# 	RoomInputs.IN_LARGE_ROOM: {},
			# }, [
			# 	{RoomInputs.HAS_BOSS: {count=2}},
			# 	RoomInputs.IN_LARGE_ROOM,
			# 	RoomInputs.IN_SPACESHIP,
			# ]
			]

	for inputs in room_inputs:
		var def = VaniaRoomDef.new({
			entity_defs=e_defs, tile_defs=t_defs,
			tile_size=opts.get("tile_size"),
			room_inputs=inputs,
			})
		defs.append(def)

	return defs
