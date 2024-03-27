extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"
class_name VaniaGame

# func to_printable():
# 	return {level_def=level_def.get_display_name()}

var generator = VaniaGenerator.new()

func _ready():
	MetSys.reset_state()
	MetSys.set_save_data()

	var room_paths = generator.generate_map()

	room_loaded.connect(init_room, CONNECT_DEFERRED)
	if room_paths.is_empty():
		Log.warn("No room_paths returned, did the generator fail?")
		return
	else:
		load_room(room_paths[0])

	Dino.spawn_player({level_node=self, deferred=false})

	var p = Dino.current_player_node()
	Log.pr("current player node", p)
	if p:
		set_player(p)

	add_module.call_deferred("RoomTransitions.gd")

func init_room():
	Log.pr("room entered", MetSys.get_current_room_instance())
	Log.pr("player coords", MetSys.get_current_coords())
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
