extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"
class_name VaniaGame

var starting_map: String = "VaniaMap.tscn" # TODO create this, i guess

func _ready():
	MetSys.reset_state()

func set_player(p: Node2D):
	Log.pr("setting player", p)
	# connect player to MetSys.set_player_position call
	super.set_player(p)

	room_loaded.connect(init_room, CONNECT_DEFERRED)
	load_room(starting_map)

	# var start := map.get_node_or_null(^"SavePoint")
	# if start:
	# 	player.position = start.position

	add_module("RoomTransitions.gd")

func init_room():
	Log.pr("room entered")
	# MetSys.get_current_room_instance().adjust_camera_limits($Player/Camera2D)
	# player.on_enter()

var level_def: LevelDef
var level_node

func setup_level(def, opts):
	level_def = def
	level_node = DinoLevel.create_level(def)
	level_node.ready.connect(_on_level_ready.bind(opts))

func _on_level_ready(opts):
	# increase difficulty with `round_num`
	var level_opts = {seed=opts.seed, }

	if level_node.has_method("regenerate"):
		level_node.regenerate(level_opts)
	else:
		Log.warn("Game/Level missing expected regenerate function!", level_node)
