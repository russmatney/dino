@tool
extends Node
class_name DinoData

## static data/helpers ########################################################

enum GameType {SideScroller, TopDown, BeatEmUp}

static func to_game_type(s: String) -> GameType:
	match s:
		"sidescroller": return GameType.SideScroller
		"topdown": return GameType.TopDown
		"beatemup": return GameType.BeatEmUp
		_:
			Log.warn("no match in to_game_type, returning fallback", s)
			return GameType.SideScroller

## current game ##########################################################

var game_mode
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

var player_set = PlayerSet.new()

func spawn_player():
	pass

func respawn_player():
	# var p = players.filter(func(p): return p.is_focused)
	pass
