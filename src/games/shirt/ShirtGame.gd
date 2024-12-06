@tool
extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"
class_name ShirtGame

# this script based initially on MetSys/SampleProject/Scripts/Game.gd

@export_file("*.tscn") var first_room: String
@export var shirt_metsys_settings = preload("res://src/games/shirt/ShirtMetSysSettings.tres")
@export var player_entity: DinoPlayerEntity


func _enter_tree():
	Vania.reset_metsys_context(self, shirt_metsys_settings)

func _exit_tree():
	for m in modules:
		m._deinit()
	# U._disconnect(Metro.travel_requested, load_travel_room)

func _ready():
	if Engine.is_editor_hint():
		return

	MetSys.reset_state()
	MetSys.set_save_data()

	# Metro.travel_requested.connect(load_travel_room)

	room_loaded.connect(on_room_loaded, CONNECT_DEFERRED)

	Dino.player_ready.connect(func(p):
		Log.pr("player ready", p)
		if p:
			set_player(p), CONNECT_DEFERRED)

	Dino.create_new_player({entity=player_entity, genre=DinoData.GenreType.TopDown})

	if OS.get_environment("__metsys_first_room__"):
		var first_room_overwrite = OS.get_environment("__metsys_first_room__")
		Log.warn("[DEV] Running custom room", first_room_overwrite)
		load_room(first_room_overwrite)
	else:
		Log.info("Running first room", first_room)
		load_room(first_room)

	add_modules()

func add_modules():
	var paths = ["res://src/games/shirt/ShirtRoomTransitions.gd"]
	for p in paths:
		var module: MetSysModule = load(p).new(self)
		modules.append(module)

func on_room_loaded():
	MetSys.get_current_room_instance().adjust_camera_limits($Camera2D)
	if not Dino.current_player_node():
		Dino.spawn_player()

# overwriting the parent b/c the player doesn't always exist
func _physics_tick():
	if can_process():
		if is_instance_valid(player):
			MetSys.set_player_position(player.position)
