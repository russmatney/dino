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

var room_defs = [
	{
		room_scene=vania_room,
		coords=[Vector3i(0, 0, 0)],
	}, {
		room_scene=vania_room_wide,
		coords=[Vector3i(1, 0, 0), Vector3i(2, 0, 0),]
	}, {
		room_scene=vania_room_tall,
		coords=[Vector3i(3, 0, 0), Vector3i(3, 1, 0),]
	}, {
		room_scene=vania_room_4x,
		coords=[
			Vector3i(4, 1, 0), Vector3i(4, 2, 0),
			Vector3i(5, 1, 0), Vector3i(5, 2, 0),
			]
	}
	]

func generate_map():
	DirAccess.make_dir_absolute(GEN_MAP_DIR)
	for file in DirAccess.get_files_at(GEN_MAP_DIR):
		DirAccess.remove_absolute(GEN_MAP_DIR.path_join(file))

	var builder := MetSys.get_map_builder()
	var room_paths = []

	for opts in room_defs:
		var coords = opts.get("coords")
		var new_room_path

		for coord in coords:
			var cell := builder.create_cell(coord)
			cell.color = MAP_CELL_BG_COLOR
			for i in 4:
				cell.borders[i] = 0
				cell.border_colors[i] = MAP_CELL_BORDER_COLOR

			if not new_room_path:
				new_room_path = build_scene_name(U.merge(opts, {idx=len(room_paths)}))
				room_paths.append(new_room_path)

			cell.set_assigned_scene(new_room_path)

		# Does this need to be called before set_assigned_scene ?
		prepare_scene(U.merge(opts, {room_path=new_room_path}))

	builder.update_map()

	return room_paths

func build_scene_name(opts={}) -> String:
	var res_path = opts.get("room_scene").resource_path
	var basename = res_path.get_file().get_basename()
	Log.pr("resource path", res_path, "basename", basename)
	var new_map = "%s%d.tscn" % [basename, opts.get("idx") + 1]
	return GEN_MAP_DIR.path_join(new_map)

func prepare_scene(opts={}):
	# Prepare the actual scene (maybe deferred if threading)
	var room: Node2D = opts.get("room_scene").instantiate()

	# do things like hide/show exits based on room opts, neighbors

	var ps := PackedScene.new()
	ps.pack(room)
	ResourceSaver.save(ps, opts.get("room_path"))
