extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"
class_name VaniaGame

var starting_map: String = "VaniaMap.tscn"

func _ready():
	MetSys.reset_state()
	MetSys.set_save_data()

	var p = Dino.current_player_node()
	Log.pr("current player node", p)
	if p:
		set_player(p)

	room_loaded.connect(init_room, CONNECT_DEFERRED)
	load_room(starting_map)

	# var start := map.get_node_or_null(^"SavePoint")
	# if start:
	# 	player.position = start.position

	add_module.call_deferred("RoomTransitions.gd")

func init_room():
	Log.pr("room entered")
	# MetSys.get_current_room_instance().adjust_camera_limits($Player/Camera2D)
	# player.on_enter()

var level_def: LevelDef
var level_node
var level_opts

func add_level(node, def, opts):
	level_node = node
	level_def = def
	level_opts = opts

	add_child(level_node)
