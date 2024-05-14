extends RefCounted
class_name VaniaGenerator

const GEN_MAP_DIR = "user://vania_maps"
static var global_room_num = 0

var neighbor_data = {}
var all_room_defs: Array[VaniaRoomDef] = []

func _init():
	# ensure directory exists
	DirAccess.make_dir_absolute(GEN_MAP_DIR)

## generate_map ##########################################################

func generate_map(map_def: MapDef) -> Array[VaniaRoomDef]:
	var defs = VaniaRoomDef.to_defs(map_def)
	return add_rooms(defs)

## add_rooms ##########################################################

func add_rooms(room_defs: Array[VaniaRoomDef]) -> Array[VaniaRoomDef]:
	var builder = MetSys.get_map_builder()

	place_rooms(room_defs)

	var defs = []

	for room_def in room_defs:
		if room_def.map_cells.is_empty():
			Log.warn("Cannot create room without map_cells", room_def)
			continue

		if not room_def.room_path:
			set_room_scene_path(room_def)

		for coord in room_def.map_cells:
			var cell = builder.create_cell(coord)
			cell.color = room_def.bg_color
			for i in 4:
				cell.borders[i] = 0
				cell.border_colors[i] = room_def.border_color

			cell.set_assigned_scene.call_deferred(room_def.room_path)

		defs.append(room_def)
	builder.update_map.call_deferred()

	# update all_room_defs
	all_room_defs.append_array(defs)

	# build room and rebuild neighbors

	update_neighbor_data()

	var neighbor_defs = []
	for rd in room_defs:
		neighbor_defs.append_array(get_neighbor_defs(rd))

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
	for file in DirAccess.get_files_at(GEN_MAP_DIR):
		if file in cleared_room_paths:
			DirAccess.remove_absolute(GEN_MAP_DIR.path_join(file))

	# collect neighbor defs first
	var neighbor_defs = []
	for rd in room_defs:
		neighbor_defs.append_array(get_neighbor_defs(rd))

	# remove from all_room_defs
	for def in room_defs:
		all_room_defs.erase(def)

	# update neighbor data
	update_neighbor_data()

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

func update_neighbor_data():
	# clear and rebuild? maybe that's fine?
	neighbor_data = {}

	for rd in all_room_defs:
		neighbor_data[rd.room_path] = rd.build_neighbor_data()

func get_neighbor_defs(room_def: VaniaRoomDef):
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
	room_def.room_path = GEN_MAP_DIR.path_join(new_map)

## prepare scene ##############################################################

func build_and_prep_scene(room_def, _opts={}):
	Debug.notif({msg="[GENNING... [color=crimson]%s[/color]]" % room_def.room_path.get_file(), rich=true})
	Log.info("generating and packing room", room_def.room_path.get_file())
	# Prepare the actual scene (maybe deferred if threading)
	var room: Node2D = load(room_def.base_scene_path).instantiate()
	# unique name for unique hotel entries?
	room.name = "%s%s" % [room.name, room_def.index]
	room.build_room(room_def, {neighbor_data=neighbor_data.get(room_def.room_path)})
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
	var map_rect = Reptile.get_recti(existing_map_cells.keys())
	var possible_rect = map_rect
	possible_rect.position -= def_rect.position + def_rect.size
	possible_rect.size += def_rect.size + Vector2i.ONE

	var possible = []
	if existing_map_cells.is_empty():
		possible = [Vector3i()]
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
