@tool
extends Node
class_name DinoData

## static data/helpers ########################################################

enum RoomType {SideScroller, TopDown, BeatEmUp}

static func to_room_type(s: String) -> RoomType:
	match s.to_lower():
		"sidescroller", "ss": return RoomType.SideScroller
		"topdown", "td": return RoomType.TopDown
		"beatemup", "beu": return RoomType.BeatEmUp
		_:
			Log.warn("no match in to_room_type, returning fallback", s)
			return RoomType.SideScroller

## vars ##########################################################

var player_set = PlayerSet.new()
var game_mode: DinoModeEntity

signal player_ready(player)

## seeding ##########################################################

var egg: int

func reseed():
	egg = randi()
	seed(egg)

## ready ##########################################################

func _ready():
	reseed()
	player_set.new_player_ready.connect(func(p):
		player_ready.emit(p))

## current game ##########################################################

func set_game_mode(mode: DinoModeEntity):
	game_mode = mode

func get_game_mode():
	if game_mode:
		return game_mode
	return Pandora.get_entity(ModeIds.DEBUG)

func is_debug_mode():
	return get_game_mode().get_entity_id() == ModeIds.DEBUG

## launch/start game ##########################################################

func launch(mode: DinoModeEntity, opts={}):
	game_mode = mode
	# TODO menu should support a mode with or without a menu
	if mode.get_menu() != null:
		mode.nav_to_menu()
		return

	restart_game(opts)

func restart_game(opts=null):
	var mode = get_game_mode()
	Log.pr("Starting game mode", mode.get_display_name())
	mode.start(opts)

## player(s) ########################################################

func create_new_player(opts):
	# maybe create a unique player instance here?
	player_set.create_new(opts)

# only creates a player if none exists
# intended for debug/dev mode
func ensure_player_setup(opts):
	if not current_player_entity():
		create_new_player(opts)

func spawn_player(opts={}):
	player_set.spawn_new(opts)

func respawn_active_player(opts={}):
	player_set.respawn_active_player(opts)

func current_player_node():
	var p = player_set.active_player()
	if p:
		return p.node

func current_player_entity():
	var p = player_set.active_player()
	if p:
		return p.entity
