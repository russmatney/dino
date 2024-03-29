extends RefCounted
class_name VaniaGenerator

const GEN_MAP_DIR = "user://vania_maps"

var entity_defs_path = "res://src/dino/modes/vania/entities.txt"
var room_defs: Array[VaniaRoomDef] = []

var tile_size = 16 # TODO fixed? dynamic?

## init ##########################################################

func _init():
	var entity_defs = GridParser.parse({defs_path=entity_defs_path})

	room_defs = VaniaRoomDef.generate_defs({
		entity_defs=entity_defs,
		tile_size=tile_size,
		count=6,
		})


## generate_rooms ##########################################################

func generate_rooms():
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
	Log.pr("attaching rooms, cells:", MetSys.map_data.cells)
	var map_cells = {}
	for coord in MetSys.map_data.cells.keys():
		if coord.x < 0 and coord.y < 0:
			# HEADS UP! skipping 'test' rooms in the negative quadrant
			# TODO use layers instead
			continue
		map_cells[coord] = true

	for def in defs:
		attach_room(map_cells, def)

func attach_room(map_cells, def):
	var def_rect = Reptile.get_recti(def.local_cells)
	var map_rect = Reptile.get_recti(map_cells.keys())
	var possible_rect = map_rect
	possible_rect.position -= def_rect.position
	possible_rect.size += def_rect.size

	Log.pr("def_rect", def_rect)
	Log.pr("map_rect", map_rect)
	Log.pr("possible rect", possible_rect)

	var possible_start_coords = []
	for start_coord in Reptile.cells_in_rect(possible_rect):
		start_coord = Vector3i(start_coord.x, start_coord.y, 0)
		if is_fit(start_coord, map_cells, def.get_local_cells_dict()):
			possible_start_coords.append(start_coord)

	if possible_start_coords.is_empty():
		Log.warn("Could not find a possible start coord for room def", def)
		return

	var start_coord = possible_start_coords.pick_random()
	Log.pr("found valid start_coord", start_coord)

	for cell in def.local_cells:
		# set room's map_cells for drawing
		def.map_cells.append(start_coord + cell)
		# update map_cells (in-place!) for the next room
		map_cells[start_coord + cell] = true


func is_fit(start_coord, map_cells, local_cells):
	for coord in local_cells:
		var map_val = map_cells.get(coord + start_coord)
		if map_val == true: # already cell here!
			return false
	return true
