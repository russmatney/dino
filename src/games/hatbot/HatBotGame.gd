@tool
extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"
class_name HatBotGame

# this script based initially on MetSys/SampleProject/Scripts/Game.gd

@export_file("res://src/games/hatbot/rooms/*.tscn") var first_room: String
@export var hatbot_metsys_settings = preload("res://src/games/hatbot/HatBotMetSysSettings.tres")
@export var player_entity: DinoPlayerEntity

func _enter_tree():
	Vania.reset_metsys_context(self, hatbot_metsys_settings)

func _exit_tree():
	for m in modules:
		m._deinit()
	U._disconnect(Metro.travel_requested, load_travel_room)

## ready ##################################################################

func _ready():
	if Engine.is_editor_hint():
		return

	MetSys.reset_state()
	MetSys.set_save_data()

	Metro.travel_requested.connect(load_travel_room)

	room_loaded.connect(on_room_loaded, CONNECT_DEFERRED)

	Dino.player_ready.connect(func(p):
		Log.pr("player ready", p)
		if p:
			set_player(p), CONNECT_DEFERRED)

	Dino.create_new_player({entity=player_entity, genre=DinoData.Genre.SideScroller})

	if OS.get_environment("__metsys_first_room__"):
		var first_room_overwrite = OS.get_environment("__metsys_first_room__")
		Log.warn("[DEV] Running custom room", first_room_overwrite)
		load_room(first_room_overwrite)
	else:
		Log.info("Running first room", first_room)
		load_room(first_room)

	add_modules()

func add_modules():
	var paths = [
		"res://src/games/hatbot/HatBotRoomTransitions.gd"
		]
	for p in paths:
		var module: MetSysModule = load(p).new(self)
		modules.append(module)

func on_room_loaded():
	adjust_camera_limits()
	if not Dino.current_player_node():
		Dino.spawn_player()

func adjust_camera_limits():
	var room = MetSys.get_current_room_instance()
	var size = room.get_size()
	Log.pr("adjusting camera limits", room, size)

	if player and player.pcam:
		player.pcam.set_limit_left(0)
		player.pcam.set_limit_top(0)
		player.pcam.set_limit_right(size.x)
		player.pcam.set_limit_bottom(size.y)

# overwriting the parent b/c the player doesn't always exist
func _physics_tick():
	if can_process():
		if is_instance_valid(player):
			MetSys.set_player_position(player.position)

var move_to_travel_point: bool = false

func load_travel_room(opts: Dictionary):
	Log.pr("hatbot loading travel-requested room", opts)
	move_to_travel_point = true
	await load_room(opts.get("destination"))

	var tp = U.first_node_in_group(map, "travel_points")
	player.position = tp.position
