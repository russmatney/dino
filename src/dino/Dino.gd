extends Node
class_name DinoData


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

