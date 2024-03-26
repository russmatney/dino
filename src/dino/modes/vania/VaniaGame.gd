extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"
class_name VaniaGame

const GEN_MAP_DIR = "user://vania_maps"
const MAP_DIR = "res://src/dino/modes/vania/maps"
var starting_map: String = "VaniaMap.tscn"
var new_generated_maps = []

var generating: Thread

# func to_printable():
# 	return {level_def=level_def.get_display_name()}

func _ready():
	MetSys.reset_state()
	MetSys.set_save_data()

	generate_map()

	room_loaded.connect(init_room, CONNECT_DEFERRED)
	if new_generated_maps.is_empty():
		load_room(starting_map)
	else:
		load_room(new_generated_maps[0])

	Dino.spawn_player({level_node=self, deferred=false})

	var p = Dino.current_player_node()
	Log.pr("current player node", p)
	if p:
		set_player(p)

	add_module.call_deferred("RoomTransitions.gd")

func init_room():
	Log.pr("room entered", MetSys.get_current_room_instance())
	Log.pr("map ", MetSys.get_save_data())
	Log.pr("map data ", MetSys.map_data)
	Log.pr("map data cells", MetSys.map_data.cells)
	Log.pr("map data assigned scenes", MetSys.map_data.assigned_scenes)
	Log.pr("player corods", MetSys.get_current_coords())
	Log.pr("this room's cells", MetSys.get_current_room_instance().get_local_cells())
	# MetSys.get_current_room_instance().adjust_camera_limits($Player/Camera2D)
	# player.on_enter()

## dino level ##########################################################

var level_def: LevelDef
var level_node
var level_opts

func add_level(node, def, opts):
	level_node = node
	level_def = def
	level_opts = opts

	add_child(level_node)

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

	for coord in map_coords:
		var cell := builder.create_cell(coord)
		cell.color = Color.BLACK
		for i in 4:
			cell.borders[i] = 0
			cell.border_colors[i] = Color.WHITE

		var sc = generate_scene() # TODO probably want to pass room opts in here
		cell.set_assigned_scene(sc)

	builder.update_map()

func generate_scene() -> String:
	var map_scene: PackedScene = load("%s/%s" % [MAP_DIR, starting_map])

	var scene_basename = starting_map.get_basename()
	var new_map: String

	if new_generated_maps.is_empty():
		new_map = scene_basename + "1.tscn"
	else:
		new_map = "%s%d.tscn" % [scene_basename, new_generated_maps.back().to_int() + 1]

	var new_map_path = GEN_MAP_DIR.path_join(new_map)
	new_generated_maps.append(new_map_path)

	# Prepare the actual scene (maybe deferred if threading)
	var map_node: Node2D = map_scene.instantiate()

	# do things like hide/show exits based on nodes and room opts

	var ps := PackedScene.new()
	ps.pack(map_node)
	ResourceSaver.save(ps, new_map_path)
	return new_map_path
