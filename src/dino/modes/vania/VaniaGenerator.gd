extends RefCounted
class_name VaniaGenerator

const GEN_MAP_DIR = "user://vania_maps"

var entity_defs_path = "res://src/dino/modes/vania/entities.txt"
var cell_override_coords: Array[Vector3i] = []

var tile_size = 16 # TODO fixed? dynamic?

## reset data ##########################################################

func reset_map_data():
	for coord in cell_override_coords:
		MetSys.get_cell_override(coord, false).destroy()
		MetSys.save_data.discovered_cells.erase(coord)
	cell_override_coords = []

	MetSys.reset_state()
	MetSys.set_save_data()

## generate_rooms ##########################################################

func generate_rooms():
	var entity_defs = GridParser.parse({defs_path=entity_defs_path})

	var room_defs = VaniaRoomDef.generate_defs({
		entity_defs=entity_defs,
		tile_size=tile_size,
		count=6,
		})

	reset_map_data()

	# ensure directory exists
	DirAccess.make_dir_absolute(GEN_MAP_DIR)

	# delete contents in directory
	for file in DirAccess.get_files_at(GEN_MAP_DIR):
		DirAccess.remove_absolute(GEN_MAP_DIR.path_join(file))

	var builder := MetSys.get_map_builder()

	attach_rooms(room_defs)
	var defs = []

	for room_def in room_defs:
		if room_def.map_cells.is_empty():
			Log.warn("Cannot create room without map_cells", room_def)
			continue

		if not room_def.room_path:
			set_room_scene_path(room_def)

		for coord in room_def.map_cells:
			var cell := builder.create_cell(coord)
			cell_override_coords.append(coord)
			cell.color = room_def.bg_color
			for i in 4:
				cell.borders[i] = 0
				cell.border_colors[i] = room_def.border_color
			cell.set_assigned_scene(room_def.room_path)

		prepare_scene(room_def)
		defs.append(room_def)

	builder.update_map()

	return defs

## set_room_scene_path ##############################################################

func set_room_scene_path(room_def):
	var basename = room_def.base_scene_path.get_file().get_basename()
	var new_map = "%s%d.tscn" % [basename, room_def.index + 1]
	room_def.room_path = GEN_MAP_DIR.path_join(new_map)

## prepare scene ##############################################################

func prepare_scene(room_def):
	# Prepare the actual scene (maybe deferred if threading)
	var room: Node2D = load(room_def.base_scene_path).instantiate()

	room.set_room_def(room_def)

	# TODO generate tiles, add entities, default doors, etc
	# hide/show exits based on room opts, neighbors

	# pack and write to room_def.room_path
	var ps := PackedScene.new()
	ps.pack(room)
	ResourceSaver.save(ps, room_def.room_path)

## attach_rooms ##########################################################

# Finds valid cells to place rooms on the map
# sets `map_cells` on each room_def
func attach_rooms(defs: Array[VaniaRoomDef]):
	var map_cells = {}
	for coord in MetSys.map_data.cells.keys():
		if coord.x < 0 and coord.y < 0:
			# HEADS UP! skipping 'test' rooms in the negative quadrant
			# TODO use layers instead
			continue
		map_cells[coord] = true

	var is_first = true
	for def in defs:
		attach_room(map_cells, def, is_first)
		is_first = false

func attach_room(map_cells, def, is_first):
	var def_rect = Reptile.get_recti(def.local_cells)
	var map_rect = Reptile.get_recti(map_cells.keys())
	var possible_rect = map_rect
	possible_rect.position -= def_rect.position
	possible_rect.size += def_rect.size

	var possible_start_coords = []
	for start_coord in Reptile.cells_in_rect(possible_rect):
		start_coord = Vector3i(start_coord.x, start_coord.y, 0)
		if no_conflicting_cells(start_coord, map_cells, def.get_local_cells_dict()) and \
			(is_first or has_neighbor(start_coord, map_cells, def.get_local_cells_dict())):
			possible_start_coords.append(start_coord)

	if possible_start_coords.is_empty():
		Log.warn("Could not find a possible start coord for room def", def)
		return

	var start_coord = possible_start_coords.pick_random()

	for cell in def.local_cells:
		# set room's map_cells for drawing
		def.map_cells.append(start_coord + cell)
		# update map_cells (in-place!) for the next room
		map_cells[start_coord + cell] = true


func no_conflicting_cells(start_coord, map_cells, local_cells):
	for coord in local_cells:
		var map_val = map_cells.get(coord + start_coord)
		if map_val == true: # already cell here!
			return false
	return true

func neighbor_coords(coord):
	return [
		coord + Vector3i(1, 0, 0),
		coord + Vector3i(-1, 0, 0),
		coord + Vector3i(0, 1, 0),
		coord + Vector3i(0, -1, 0),
		]

func has_neighbor(start_coord, map_cells, local_cells):
	for coord in local_cells:
		var map_coord = coord + start_coord
		var nbr_coords = neighbor_coords(map_coord)
		var has_nbr = nbr_coords.any(func(nc): return map_cells.get(nc))
		if has_nbr:
			return true
	return false
