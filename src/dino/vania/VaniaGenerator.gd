@tool
extends RefCounted
class_name VaniaGenerator

const FALLBACK_GEN_MAP_DIR = "user://vania_maps"
var gen_map_dir
static var global_room_num = 0

var neighbor_data = {}
var all_room_defs: Array[VaniaRoomDef] = []

# TODO set minimap theme more consciously

func _init(map_dir = null, generation_label = null):
	# ensure directory exists
	if map_dir != null:
		# TODO some label for _this_ unique build
		gen_map_dir = "%s%s" % [map_dir, generation_label]
	if gen_map_dir == null:
		gen_map_dir = FALLBACK_GEN_MAP_DIR
	DirAccess.make_dir_absolute(gen_map_dir)

## generate_map ##########################################################

func generate_map(map_def: MapDef) -> Array[VaniaRoomDef]:
	# question these resets/inits, maybe want them optional?
	MetSys.reset_state()
	MetSys.set_save_data()

	var defs = VaniaRoomDef.to_defs(map_def)
	return add_rooms(defs)

## add_rooms ##########################################################

var neighbor_dirs = [
	Vector3i(1, 0, 0), Vector3i(-1, 0, 0),
	Vector3i(0, 1, 0), Vector3i(0, -1, 0),
	]

func add_rooms(room_defs: Array[VaniaRoomDef]) -> Array[VaniaRoomDef]:
	Log.info("Adding rooms:", len(room_defs))
	var builder = MetSys.get_map_builder()

	place_rooms(room_defs)

	var defs = []

	for room_def in room_defs:
		if room_def.map_cells.is_empty():
			Log.warn("Cannot create room without map_cells", room_def)
			continue

		if not room_def.room_path:
			set_room_scene_path(room_def)

		defs.append(room_def)

	# update all_room_defs
	all_room_defs.append_array(defs)

	# rebuild neighbors/doors on all room_defs
	rebuild_doors()

	for room_def in room_defs:
		for coord in room_def.map_cells:
			var cell = builder.create_cell(coord)
			cell.color = room_def.get_bg_color()

			var door_dirs = []
			for door in room_def.doors:
				if coord in door:
					var dir = door[1] - door[0]
					door_dirs.append(Vector2i(dir.x, dir.y))

			var same_room_dirs = []
			for neighbor_dir in neighbor_dirs:
				var nbr_cell = coord + neighbor_dir
				if nbr_cell in room_def.map_cells:
					same_room_dirs.append(Vector2i(neighbor_dir.x, neighbor_dir.y))

			for i in 4:
				var border_dir = MetroidvaniaSystem.MapData.FWD[i]
				cell.border_colors[i] = room_def.get_border_color()

				# 0 - wall, 1 - passage, 2+ - per theme, -1 - no border
				if border_dir in door_dirs:
					cell.borders[i] = 1 # passage
				elif border_dir in same_room_dirs:
					cell.borders[i] = -1 # no wall (same room)
				else:
					cell.borders[i] = 0 # wall

			cell.set_assigned_scene.call_deferred(room_def.room_path)
	builder.update_map.call_deferred()

	# gather neighboring rooms to repack
	var neighbor_defs = []
	for rd in room_defs:
		neighbor_defs.append_array(get_neighbor_defs(rd))

	# build/pack all affected rooms
	var to_build = []
	to_build.append_array(room_defs)
	to_build.append_array(neighbor_defs)
	for n_def in U.distinct(to_build):
		# rebuild and pack scenes + neighbor scenes!
		build_and_prep_scene(n_def)

	return all_room_defs

## remove rooms ##########################################################

func remove_rooms(room_defs: Array[VaniaRoomDef]) -> Array[VaniaRoomDef]:
	var coords = []

	if not room_defs.is_empty():
		room_defs.map(func(rd):
			coords.append_array(rd.map_cells))

	for coord in coords:
		# also clear visited cells? they seem to stick around
		VaniaGenerator.remove_cell_override_from_builder(coord)

	# delete contents in directory
	var cleared_room_paths = room_defs.map(func(rd): return rd.room_path)
	for file in DirAccess.get_files_at(gen_map_dir):
		if file in cleared_room_paths:
			DirAccess.remove_absolute(gen_map_dir.path_join(file))

	# collect neighbor defs first
	var neighbor_defs = []
	for rd in room_defs:
		neighbor_defs.append_array(get_neighbor_defs(rd))

	# remove from all_room_defs
	for def in room_defs:
		all_room_defs.erase(def)

	# rebuild neighbors/doors on all room_defs
	rebuild_doors()

	for n_def in U.distinct(neighbor_defs):
		# rebuild and pack neighbor scenes!
		build_and_prep_scene(n_def)

	return all_room_defs

## static helpers ##########################################################

static func remove_generated_cells():
	for coord in MetSys.map_data.cells.keys():
		remove_cell_override_from_builder(coord)

static func remove_cell_override_from_builder(coord: Vector3i):
	var override = MetSys.get_cell_override(coord, false)
	if override != null:
		override.destroy()
		MetSys.save_data.discovered_cells.erase(coord)

static func get_existing_map_cells():
	var cells = {}
	for coord in MetSys.map_data.cells.keys():
		cells[coord] = true
	return cells

## neighbor data ##########################################################

# calc and set 'doors' on all room_defs, making sure neighboring doors are consistent
func rebuild_doors():

	# clear and rebuild? maybe that's fine?
	neighbor_data = {}

	# i think i speak for everyone when I say: fuck doors.
	for room_def in all_room_defs:
		var nbr_room_data = []
		for nbr_def in all_room_defs:
			var nbr_data = {room_path=nbr_def.room_path, map_cells=nbr_def.map_cells}
			var nbrs = neighbor_data.get(nbr_def.room_path, [])
			for nbr in nbrs:
				if nbr.room_path == room_def.room_path:
					if not nbr.get("doors").is_empty():
						nbr_data.doors = nbr.get("doors")
			nbr_room_data.append(nbr_data)

		var new_nbr_data = room_def.calc_doors({neighbor_data=nbr_room_data})
		neighbor_data[room_def.room_path] = new_nbr_data

func get_neighbor_defs(room_def: VaniaRoomDef):
	# TODO ugh, get rid of this neighbor_data / rebuild_doors dep
	var nbr = neighbor_data.get(room_def.room_path)
	if nbr == null:
		Log.warn("Could not find neighbor for room_def", room_def.room_path.get_file())
		return []
	var paths = nbr.map(func(data): return data.room_path)
	var defs = []
	for path in paths:
		var rds = all_room_defs.filter(func(rd): return rd.room_path == path)
		if rds.is_empty():
			Log.warn("Could not find room_def for neighbor_path:", path.get_file())
			continue
		if len(rds) > 1:
			Log.warn("Found multiple room_defs for neighbor_path! eeeek!", path.get_file())
			continue
		defs.append(rds[0])
	return defs

## set_room_scene_path ##############################################################

func set_room_scene_path(room_def):
	var basename = room_def.base_scene_path.get_file().get_basename()
	var new_map = "%s%d.tscn" % [basename, VaniaGenerator.global_room_num]
	room_def.index = global_room_num
	VaniaGenerator.global_room_num += 1
	room_def.room_path = gen_map_dir.path_join(new_map)

## prepare scene ##############################################################

func build_and_prep_scene(room_def, _opts={}):
	Debug.notif({msg="[GENNING... [color=crimson]%s[/color]]" % room_def.room_path.get_file(), rich=true})
	Log.info("generating and packing room", room_def.room_path.get_file())
	# Prepare the actual scene (maybe deferred if threading)
	var room: Node2D = load(room_def.base_scene_path).instantiate()
	# unique name for unique hotel entries?
	room.name = "%s%s" % [room.name, room_def.index]
	room.build_room(room_def)
	room.is_debug = false

	# pack and write to room_def.room_path
	var ps = PackedScene.new()
	ps.pack(room)
	var error = ResourceSaver.save(ps, room_def.room_path)
	if error != Error.OK:
		Log.error("Error saving room scene! Error code:", error)
	Debug.notif({msg="[GENNED! [color=purple]%s[/color]]!" % room_def.room_path.get_file(), rich=true})
	Dino.notif({type="side", text="Generated [color=purple]%s[/color]" % room_def.room_path.get_file()})

## place_rooms ##########################################################

# Finds valid cells to place rooms on the map
# sets `map_cells` on each room_def
func place_rooms(defs: Array[VaniaRoomDef]):
	var existing_map_cells = VaniaGenerator.get_existing_map_cells()

	for def in defs:
		if def.local_cells.is_empty():
			Log.warn("Cannot place room without local_cells!!", def)
			continue

		attach_room(existing_map_cells, def)
		def.calc_cell_meta()

func attach_room(existing_map_cells, def):
	var possible_start_coords = get_possible_start_coords(existing_map_cells, def)

	if possible_start_coords.is_empty():
		Log.warn("Could not find a possible start coord for room def", def)
		return

	var start_coord = possible_start_coords.pick_random()

	for cell in def.local_cells:
		# set room's map_cells for drawing
		def.map_cells.append(start_coord + cell)
		# update map_cells (in-place!) for the next room
		existing_map_cells[start_coord + cell] = true

func get_possible_start_coords(existing_map_cells, def):
	var def_rect = Reptile.get_recti(def.local_cells)
	var local_cells_dict = {}
	for cell in def.local_cells:
		local_cells_dict[cell] = true
	var possible_rect
	if existing_map_cells.keys().is_empty():
		possible_rect = Rect2i()
	else:
		possible_rect = Reptile.get_recti(existing_map_cells.keys())
	possible_rect.position -= def_rect.position + def_rect.size
	possible_rect.size += def_rect.size + Vector2i.ONE

	var possible = []
	if existing_map_cells.is_empty():
		possible = [Vector3i()] # first room starts at 0,0
	else:
		var rel_neighbor_coords = relative_neighbor_coords(def)

		var found = false
		for start_coord in Reptile.cells_in_rect(possible_rect):
			start_coord = Vector3i(start_coord.x, start_coord.y, 0)
			if no_conflicting_cells(start_coord, existing_map_cells, local_cells_dict) \
				and has_neighbor(start_coord, existing_map_cells, local_cells_dict, rel_neighbor_coords):
				found = true
				possible.append(start_coord)
		if found == false:
			Log.warn("no start pos found for next room and door_mode, expanding search")
			rel_neighbor_coords = relative_neighbor_coords()

			for start_coord in Reptile.cells_in_rect(possible_rect):
				start_coord = Vector3i(start_coord.x, start_coord.y, 0)
				if no_conflicting_cells(start_coord, existing_map_cells, local_cells_dict) \
					and has_neighbor(start_coord, existing_map_cells, local_cells_dict, rel_neighbor_coords):
					possible.append(start_coord)

	return possible

func no_conflicting_cells(start_coord, existing_map_cells, local_cells_dict):
	for coord in local_cells_dict:
		var map_val = existing_map_cells.get(coord + start_coord)
		if map_val == true: # already cell here!
			return false
	return true

func relative_neighbor_coords(def: VaniaRoomDef = null):
	if not def:
		return [
			Vector3i(1, 0, 0),
			Vector3i(-1, 0, 0),
			Vector3i(0, 1, 0),
			Vector3i(0, -1, 0),
			]
	match def.neighbor_direction():
		Vector2i.LEFT:
			return [Vector3i(1, 0, 0)]
		Vector2i.RIGHT:
			return [Vector3i(-1, 0, 0)]
		Vector2i.UP:
			return [Vector3i(0, 1, 0)]
		Vector2i.DOWN:
			return [Vector3i(0, -1, 0)]

	match def.door_mode():
		VaniaRoomDef.DOOR_MODE.MINIMAL_VERTICAL:
			return [Vector3i(0, 1, 0), Vector3i(0, -1, 0)]
		VaniaRoomDef.DOOR_MODE.MINIMAL_HORIZONTAL:
			return [Vector3i(1, 0, 0), Vector3i(-1, 0, 0)]
		_:
			return [
				Vector3i(1, 0, 0),
				Vector3i(-1, 0, 0),
				Vector3i(0, 1, 0),
				Vector3i(0, -1, 0),
				]

func has_neighbor(start_coord, existing_map_cells, local_cells_dict, neighbor_coords=[]):
	if neighbor_coords.is_empty():
		neighbor_coords = relative_neighbor_coords()
	for coord in local_cells_dict:
		var map_coord = coord + start_coord
		var nbr_coords = neighbor_coords.map(func(n_crd): return map_coord + n_crd)
		var has_nbr = nbr_coords.any(func(n_crd): return existing_map_cells.get(n_crd))
		if has_nbr:
			return true
	return false
