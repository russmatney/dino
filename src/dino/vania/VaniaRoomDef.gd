@tool
extends Resource
class_name VaniaRoomDef

## static #####################################################3

static func default_input() -> MapInput:
	return MapInput.with({
		entity_ids=[DinoEntityIds.PLAYERSPAWNPOINT],
		})

static func to_defs(m_def: MapDef) -> Array[VaniaRoomDef]:
	var defs: Array[VaniaRoomDef] = []

	if m_def.rooms.is_empty():
		Log.info("No room inputs passed, ensuring at least one")
		m_def.rooms.append(MapInput.new())

	# ensure base input
	if not m_def.input:
		Log.warn("no default map_def input, creating empty")
		m_def.input = MapInput.new()

	# merge default input opts
	m_def.input = VaniaRoomDef.default_input().merge(m_def.input)

	var room_inputs = []
	for inp in m_def.rooms:
		if inp == null:
			inp = MapInput.new()
		room_inputs.append(inp)
		for _i in range(inp.dupe_room_count):
			room_inputs.append(inp)

	for inp in room_inputs:
		if not inp.skip_merge:
			inp = m_def.input.merge(inp)

		var def = VaniaRoomDef.new({input=inp})
		def.map_def = m_def
		defs.append(def)

	return defs

## vars #####################################################3

# level gen stuff
var base_scene_path = "res://src/dino/vania/maps/VaniaRoom.tscn"
var room_path: String
var tile_size = 16

var local_cells: Array #[Vector3i]
var map_cells: Array #[Vector3i]
var min_map_cell := Vector2i.MAX
var max_map_cell := Vector2i.MIN
# used to incrementing filenames per room - should be unique per map-gen
var index: int = 0

enum DOOR_MODE {
	UNSET,
	ALL_DOORS,
	MINIMAL,
	MINIMAL_HORIZONTAL,
	MINIMAL_VERTICAL,
	}

# data
@export var input: MapInput
var map_def: MapDef

# game state
var visited = false
func reset_visited():
	visited = false
func set_visited():
	visited = true

## data getters #####################################################3

func genre() -> DinoData.Genre:
	# if not input:
	# 	return DinoData.Genre.SideScroller
	return input.genre

func entities() -> Array[DinoEntity]:
	# TODO read entities from the input.grid/grids?
	if not input:
		return []
	return input.entities

func enemies() -> Array[DinoEnemy]:
	# TODO read entities from the input.grid/grids?
	if not input:
		return []
	return input.enemies

func enemy_waves() -> int:
	if not input:
		return 0
	return input.enemy_waves

func effects() -> Array[RoomEffect]:
	# TODO read effects from the input.grid/grids?
	if not input:
		return []
	return input.room_effects

func tiles() -> Array[DinoTiles]:
	if not input:
		return []
	return input.tiles

func door_mode() -> DOOR_MODE:
	if not input:
		return DOOR_MODE.ALL_DOORS
	return input.door_mode

func neighbor_direction() -> Vector2i:
	if not input:
		return Vector2i.ZERO
	return input.neighbor_direction

func skip_borders() -> Array[Vector2i]:
	if not input:
		return []
	return input.skip_borders

func get_drops() -> Array[DropData]:
	if not input:
		return []
	return input.drops

var bg_color
func get_bg_color() -> Color:
	if input and input.bg_color:
		return input.bg_color
	if not bg_color:
		bg_color = U.rand_of([Color.PERU, Color.AQUAMARINE, Color.CORAL])
	return bg_color

func get_border_color() -> Color:
	return Color(1, 1, 1, 0.7)

## log.gd #####################################################3

func to_pretty():
	return {
		input=input,
		room_path=room_path.get_file(),
		local_cells=local_cells,
		map_cells=map_cells,
		}


## rebuild #####################################################3

# rebuild the state from the input
func rebuild():
	MapInput.apply(input, self)

## init #####################################################3

func _init(opts={}):
	if opts.get("local_cells"):
		set_local_cells(opts.get("local_cells"))

	tile_size = U.get_(opts, "tile_size", tile_size)

	if opts.get("input"):
		input = opts.get("input")
		MapInput.apply(input, self)

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

func get_primary_tiles() -> DinoTiles:
	if tiles().is_empty():
		Log.warn("No tiles on room_def, cannot return primary tilemap")
		return
	else:
		return tiles()[0]

func get_secondary_tiles() -> DinoTiles:
	if tiles().is_empty():
		Log.warn("No tiles on room_def, cannot return secondary tilemap")
		return
	else:
		if len(tiles()) > 1:
			return tiles()[1]
		else:
			return tiles()[0]

## map_cells #####################################################

func calc_cell_meta(opts={}):
	for p in opts.get("cells", map_cells):
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

func get_local_width() -> int:
	return Reptile.get_width(local_cells)

func get_local_height() -> int:
	return Reptile.get_height(local_cells)

## doors/neighbors ######################################################

var doors: Array

func calc_doors(opts={}):
	var neighbor_data = opts.get("neighbor_data", [])
	if neighbor_data:
		neighbor_data = neighbor_data.duplicate(true).filter(func(nbr): return nbr.room_path != room_path)
	else:
		# NOTE this requires builder.update_map and cell.set_assigned_scene to have run
		var neighbor_paths = get_neighbor_room_paths()
		for p in neighbor_paths:
			neighbor_data.append({room_path=p, map_cells=MetSys.map_data.get_cells_assigned_to(p)})

	for ngbr in neighbor_data:
		ngbr.possible_doors = []
		for n_cell in ngbr.map_cells:
			for r_cell in map_cells:
				if is_neighboring_cell(n_cell, r_cell):
					if (not [r_cell, n_cell] in ngbr.possible_doors and
						not [n_cell, r_cell] in ngbr.possible_doors):
						ngbr.possible_doors.append([r_cell, n_cell])

	neighbor_data = neighbor_data.filter(func(n): return len(n.possible_doors) > 0)
	for ngbr in neighbor_data:
		if ngbr.get("doors"):
			continue
		# assign doors via possible_doors
		pick_doors(ngbr)

	doors = U.flat_map(neighbor_data, func(nbr): return nbr.doors).map(arrange_door)
	return neighbor_data

# setup door with this room's cell first, the nbr room's cell second
func arrange_door(door):
	var this_cell
	var neighbor_cell
	for cell in door:
		if cell in map_cells:
			this_cell = cell
		else:
			neighbor_cell = cell
	if this_cell == null or neighbor_cell == null:
		Log.error("unexpected door pair", door, "cannot create doorway")
		return []
	return [this_cell, neighbor_cell]

func is_door_for_mode(mode, door) -> bool:
	match mode:
		DOOR_MODE.MINIMAL_HORIZONTAL: # horizontal - same y
			return door[0][1] == door[1][1]
		DOOR_MODE.MINIMAL_VERTICAL: # vertical - same x
			return door[0][0] == door[1][0]
		_:
			return true

func pick_doors(neighbor):
	var _doors = []
	match door_mode():
		DOOR_MODE.MINIMAL:
			# one random door per neighbor
			_doors.append(neighbor.possible_doors.pick_random())
		DOOR_MODE.MINIMAL_VERTICAL, DOOR_MODE.MINIMAL_HORIZONTAL:
			# one vert/horiz door per neighbor
			var ds = neighbor.possible_doors.filter(func(door):
				return is_door_for_mode(door_mode(), door))
			if ds.is_empty():
				Log.warn("No horiz/vert door for neighbor", door_mode(), neighbor)
				_doors.append(neighbor.possible_doors.pick_random())
			else:
				_doors.append(ds.pick_random())
		_, DOOR_MODE.UNSET, DOOR_MODE.ALL_DOORS:
			_doors.append_array(neighbor.possible_doors)
	neighbor.doors = _doors

func get_neighbor_room_paths() -> Array[String]:
	var ret: Array[String] = []

	for cell in map_cells:
		# var cell_data: MetroidvaniaSystem.MapData.CellData = MetSys.map_data.get_cell_at(cell)
		# assert(cell_data)
		for i in 4:
			var fwd: Vector2i = MetroidvaniaSystem.MapData.FWD[i]
			var nbr_room_path: String = MetSys.map_data.get_assigned_scene_at(cell + Vector3i(fwd.x, fwd.y, 0))
			if not nbr_room_path.is_empty() and nbr_room_path != room_path and not nbr_room_path in ret:
				ret.append(nbr_room_path)

	return ret

func is_neighboring_cell(a: Vector3i, b: Vector3i) -> bool:
	if abs(a.x - b.x) == 0:
		return abs(a.y - b.y) == 1
	if abs(a.y - b.y) == 0:
		return abs(a.x - b.x) == 1
	return false

