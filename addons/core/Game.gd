@tool
extends Node

## game entities ##########################################################

func all_game_entities():
	var ent = Pandora.get_entity(DinoGameEntityIds.DOTHOP)
	return Pandora.get_all_entities(Pandora.get_category(ent._category_id))\
		.filter(func(ent): return ent.is_enabled())\
		.filter(func(ent): return not ent.is_game_mode())

func all_game_modes():
	var ent = Pandora.get_entity(DinoGameEntityIds.DOTHOP)
	return Pandora.get_all_entities(Pandora.get_category(ent._category_id))\
		.filter(func(ent): return ent.is_enabled())\
		.filter(func(ent): return ent.is_game_mode())

func game_entity_for_scene(scene):
	var gs = all_game_entities().filter(func(g): return g and g.manages_scene(scene))
	if gs.size() == 1:
		return gs[0]
	elif gs.size() == 0:
		Log.warn("No game found to manage scene", scene, scene.scene_file_path)
	else:
		Log.warn("Multiple games manage scene", scene, scene.scene_file_path, gs)

## Navi.menu register/cleanup ##########################################################

func register_menus(ent):
	Navi.set_pause_menu(ent.get_pause_menu())
	Navi.set_win_menu(ent.get_win_menu())
	Navi.set_death_menu(ent.get_death_menu())

func clear_menus():
	Navi.clear_menus()

## current game ##########################################################

func get_current_game():
	var scene = get_tree().current_scene
	if scene and "scene_file_path" in scene:
		return game_entity_for_scene(scene)
	else:
		Log.warn("Could not determine current_game from scene", scene)

## launch game ##########################################################

var _is_managed = false
func is_managed():
	# TODO how to support this without state/autoload/node
	return _is_managed

## For a passed game, load its main menu.
## If no menu set, start the game via restart_game
func launch(game: DinoGameEntity):
	_is_managed = true
	register_menus(game)
	P.set_player_scene(game)

	if game.get_main_menu() != null:
		Navi.nav_to(game.get_main_menu())
		return

	restart_game()

func restart_game(opts=null):
	Navi.resume()  # ensure unpaused

	var game = get_current_game()
	if game:
		Log.warn("Cannot (re)start_game, no current game")
		return
	if opts == null:
		opts = {}

	Log.pr("Starting game", game.get_display_name())

	var	first_level = game.get_first_level_scene()
	if first_level:
		Navi.nav_to(first_level)
		return

	Log.warn("DinoGameEntity missing 'first_level', cannot start", game)

## load main menu helper ##########################################################

# called from most pause menus to return to the game's main menu
func load_main_menu():
	var game = get_current_game()
	if game and game.get_main_menu() != null:
		Navi.nav_to(game.get_main_menu())
		return

	Log.warn("No main_menu in game_entity, naving to fallback main menu.")
	Navi.nav_to_main_menu()

