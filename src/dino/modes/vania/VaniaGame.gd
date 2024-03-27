extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"
class_name VaniaGame

# func to_printable():
# 	return {level_def=level_def.get_display_name()}

var generator = VaniaGenerator.new()
var VaniaRoomTransitions = "res://src/dino/modes/vania/VaniaRoomTransitions.gd"

var room_defs = []
var room_defs_by_path = {}

func get_room_def(path):
	if path in room_defs_by_path:
		return room_defs_by_path[path]

func add_custom_module(module_path: String):
	modules.append(load(module_path).new(self))

func _ready():
	# TODO maybe this belongs as part of VaniaGenerator, so we can regen neighbor rooms on-the-fly
	MetSys.reset_state()
	MetSys.set_save_data()

	room_defs = generator.generate_rooms()
	for rd in room_defs:
		room_defs_by_path[rd.room_path] = rd

	room_loaded.connect(init_room, CONNECT_DEFERRED)
	if room_defs.is_empty():
		Log.warn("No room_defs returned, did the generator fail?")
		return
	else:
		load_room(room_defs[0].room_path)

	Dino.spawn_player({level_node=self, deferred=false})

	get_tree().physics_frame.connect(_set_player_position, CONNECT_DEFERRED)

	add_custom_module.call_deferred(VaniaRoomTransitions)

func init_room():
	Log.pr("room entered", MetSys.get_current_room_instance())
	Log.pr("player coords", MetSys.get_current_coords())
	Log.pr("this room's cells", MetSys.get_current_room_instance().get_local_cells())
	# Log.pr("this room's neighbors", MetSys.get_current_room_instance().get_neighbor_rooms(false))

	# MetSys.get_current_room_instance().adjust_camera_limits($Player/Camera2D)
	# player.on_enter()

func _set_player_position():
	var p = Dino.current_player_node()
	if p:
		MetSys.set_player_position(p.position)

## dino level ##########################################################

var level_def: LevelDef
var level_node
var level_opts

func add_level(node, def, opts):
	level_node = node
	level_def = def
	level_opts = opts

	add_child(level_node)
