@tool
extends Resource
class_name VaniaRoomDef

## static #####################################################3

static var tile_defs_path = "res://src/dino/vania/tiles.txt"

static func to_defs(opts={}) -> Array[VaniaRoomDef]:
	var t_defs = GridParser.parse({defs_path=tile_defs_path})
	var defs: Array[VaniaRoomDef] = []

	var inputs = opts.get("inputs", [])
	var map_def = opts.get("map_def")
	if map_def and inputs.is_empty():
		inputs = map_def.inputs

	if inputs.is_empty():
		Log.warn("No room inputs passed, no defs to generate")

	for inp in inputs:
		var def = VaniaRoomDef.new({tile_defs=t_defs, input=inp})
		defs.append(def)

	return defs

## vars #####################################################3

var base_scene_path = "res://src/dino/vania/maps/VaniaRoom.tscn"
var room_path: String

var local_cells: Array #[Vector3i]
var map_cells: Array #[Vector3i]

var min_map_cell := Vector2i.MAX
var max_map_cell := Vector2i.MIN

var bg_color: Color = Color.BLACK
var border_color: Color = Color.WHITE

var tile_defs: GridDefs
var tile_size = 16

var index: int = 0

@export var input: RoomInput

func to_printable():
	return {
		input=input,
		room_path=room_path.get_file(),
		local_cells=local_cells,
		map_cells=map_cells,
		}

## data #####################################################3

func genre_type() -> DinoData.GenreType:
	return input.genre_type

func entities() -> Array[DinoEntity]:
	return input.entities

func enemies() -> Array[DinoEnemy]:
	return input.enemies

func effects() -> Array[RoomEffect]:
	return input.room_effects

func tilemap_scenes() -> Array[PackedScene]:
	if input:
		return input.tilemap_scenes
	return []

## input #####################################################3

func rebuild():
	RoomInput.apply(input, self)

## init #####################################################3

func _init(opts={}):
	if opts.get("local_cells"):
		set_local_cells(opts.get("local_cells"))

	bg_color = opts.get("bg_color", bg_color)
	border_color = opts.get("border_color", border_color)

	tile_defs = opts.get("tile_defs")
	if not tile_defs:
		tile_defs = GridParser.parse({defs_path=VaniaRoomDef.tile_defs_path})

	tile_size = U.get_(opts, "tile_size", tile_size)

	if opts.get("input"):
		input = opts.get("input")
		RoomInput.apply(input, self)

## local cells #####################################################3

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
	if tilemap_scenes().is_empty():
		Log.warn("No tilemap_scenes on room_def, cannot return primary tilemap")
		return
	else:
		return tilemap_scenes()[0]

func get_secondary_tilemap():
	if tilemap_scenes().is_empty():
		Log.warn("No tilemap_scenes on room_def, cannot return secondary tilemap")
		return
	else:
		if len(tilemap_scenes()) > 1:
			return tilemap_scenes()[1]
		else:
			return tilemap_scenes()[0]

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

