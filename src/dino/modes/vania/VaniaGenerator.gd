extends RefCounted
class_name VaniaGenerator

const GEN_MAP_DIR = "user://vania_maps"
const MAP_CELL_BG_COLOR = Color.BLACK
const MAP_CELL_BORDER_COLOR = Color.WHITE

const vania_room = preload("res://src/dino/modes/vania/maps/VaniaRoom.tscn")
const vania_room_wide = preload("res://src/dino/modes/vania/maps/VaniaRoomWide.tscn")
const vania_room_tall = preload("res://src/dino/modes/vania/maps/VaniaRoomTall.tscn")
const vania_room_4x = preload("res://src/dino/modes/vania/maps/VaniaRoom4x.tscn")

## generate_map ##########################################################

var map_coords = [
	Vector3i(0, 0, 0),
	Vector3i(1, 0, 0),
	Vector3i(2, 0, 0),
	Vector3i(2, 1, 0),
	Vector3i(1, 1, 0),
	]

func generate_map():
	DirAccess.make_dir_absolute(GEN_MAP_DIR)
	for file in DirAccess.get_files_at(GEN_MAP_DIR):
		DirAccess.remove_absolute(GEN_MAP_DIR.path_join(file))

	var builder := MetSys.get_map_builder()
	var map_paths = []

	for coord in map_coords:
		var cell := builder.create_cell(coord)
		cell.color = MAP_CELL_BG_COLOR
		for i in 4:
			cell.borders[i] = 0
			cell.border_colors[i] = MAP_CELL_BORDER_COLOR

		var new_map_path = generate_scene({room_idx=len(map_paths)})
		map_paths.append(new_map_path)
		cell.set_assigned_scene(new_map_path)

	builder.update_map()

	return map_paths


func generate_scene(opts={}) -> String:
	var new_map = "%s%d.tscn" % [vania_room.get_basename(), opts.get("room_idx") + 1]
	var new_map_path = GEN_MAP_DIR.path_join(new_map)

	# Prepare the actual scene (maybe deferred if threading)
	var map_node: Node2D = vania_room.instantiate()

	# do things like hide/show exits based on nodes and room opts

	var ps := PackedScene.new()
	ps.pack(map_node)
	ResourceSaver.save(ps, new_map_path)
	return new_map_path
