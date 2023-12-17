extends Node
class_name DinoData


## current game ##########################################################

var game_mode
func get_game_mode():
	if game_mode:
		return game_mode
	Log.warn("No game mode set, returning Debug mode")
	return Pandora.get_entity(ModeIds.DEBUG)

## launch game ##########################################################

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

## load main menu helper ##########################################################

# called from most pause menus to return to the game's main menu
# TODO drop and use navi? or move navi menu logic here?
func load_main_menu():
	Navi.nav_to_main_menu()
