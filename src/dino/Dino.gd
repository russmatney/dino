@tool
extends Node
class_name DinoData

## static data/helpers ########################################################

enum Genre {SideScroller, TopDown, BeatEmUp}

static func to_genre(s: String) -> Genre:
	match s.to_lower():
		"sidescroller", "ss": return Genre.SideScroller
		"topdown", "td": return Genre.TopDown
		"beatemup", "beu": return Genre.BeatEmUp
		_:
			Log.warn("no match in to_genre, returning fallback", s)
			return Genre.SideScroller

## vars ##########################################################

# TODO these global Dino.gd player_set and game_mode interactions need a clearer API
# maybe could be grouped more like save/session game-state
var player_set = PlayerSet.new()
var game_mode: DinoModeEntity

var main_menu_scene = preload("res://src/dino/menus/main/DinoMenu.tscn")
var pause_menu_scene = preload("res://src/dino/menus/pause/DinoPauseMenu.tscn")
var death_menu_scene: PackedScene = preload("res://addons/bones/navi/NaviDeathMenu.tscn")
var win_menu_scene: PackedScene = preload("res://addons/bones/navi/NaviWinMenu.tscn")

## signals ##########################################################

signal player_ready(player)
signal notification(opts)

## seeding ##########################################################

var _seed: int

func reseed():
	_seed = randi()
	seed(_seed)

func get_seed():
	return _seed

## enter tree ##########################################################

func _enter_tree():
	Log.set_colors_pretty()

## ready ##########################################################

func _ready():
	reseed()
	player_set.new_player_ready.connect(func(p):
		player_ready.emit(p))

	Navi.set_main_menu(main_menu_scene)
	Navi.set_pause_menu(pause_menu_scene)
	Navi.set_death_menu(death_menu_scene)
	Navi.set_win_menu(win_menu_scene)

## current game ##########################################################

func set_game_mode(mode: DinoModeEntity):
	game_mode = mode

func get_game_mode():
	if game_mode:
		return game_mode
	Log.warn("no game mode set, returning debug!")
	return Pandora.get_entity(ModeIds.DEBUG)

func is_debug_mode():
	return get_game_mode().get_entity_id() == ModeIds.DEBUG

## launch/start game ##########################################################

func start_game_mode(mode: DinoModeEntity, opts={}):
	reset_player_data()
	game_mode = mode

	if mode.get_menu() != null:
		mode.nav_to_menu()
		return

	restart_game(opts)

func restart_game(opts=null):
	var mode = get_game_mode()
	Log.info("Starting game mode", mode.get_display_name())
	mode.start(opts)

## player(s) ########################################################

func create_new_player(opts):
	# maybe create a unique player instance here?
	# i.e. with name and traits and history
	player_set.create_new(opts)

# only creates a player if none exists
# intended for debug/dev mode
# ....dear past-me: wtf?
func ensure_player_setup(opts={}):
	if not current_player_entity():
		if opts == null or opts.get("entity") == null:
			var genre = opts.get("genre")
			var ent = DinoPlayerEntity.get_random({genre=genre})
			Log.warn("no player_entity, creating random", ent, opts)
			create_new_player({entity=ent, genre=opts.get("genre")})
		else:
			Log.pr("creating player with opts", opts)
			create_new_player(opts)

func spawn_player(opts={}):
	player_set.spawn_new(opts)

func respawn_active_player(opts={}):
	player_set.respawn_active_player(opts)

func current_player_node():
	var p = player_set.active_player()
	if p and p.node and is_instance_valid(p.node):
		return p.node

func current_player_entity():
	var p = player_set.active_player()
	if p:
		return p.entity

func reset_player_data():
	player_set.reset_player_data()

## notifications ##########################################################

func notif(opts):
	(func(): notification.emit(opts)).call_deferred()
