@tool
extends Node

## game entities ##########################################################

func all_game_entities():
	var ent = Pandora.get_entity(DinoGameEntityIds.DOTHOP)
	return Pandora.get_all_entities(Pandora.get_category(ent._category_id))\
		.filter(func(e): return e.is_enabled())

func basic_game_entities():
	return all_game_entities().filter(func(e): return not e.is_game_mode())

func game_entity_for_scene(sfp, opts={}):
	var gs
	if opts.get("all"):
		gs = all_game_entities().filter(func(g): return g and g.manages_scene(sfp))
	else:
		gs = basic_game_entities().filter(func(g): return g and g.manages_scene(sfp))
	if gs.size() == 1:
		return gs[0]
	elif gs.size() == 0:
		Log.warn("No game found to manage scene", sfp)
	else:
		Log.warn("Multiple games manage scene", sfp, gs)

func get_game_entity(ent_id):
	return Pandora.get_entity(ent_id)

## current game ##########################################################

func get_current_game(opts={}):
	var sfp = Navi.current_scene_path()
	if sfp:
		if opts.get("all"):
			var game_entity = game_entity_for_scene(sfp, opts)
			if game_entity:
				return game_entity
		else:
			var game_entity = game_entity_for_scene(sfp)
			if game_entity:
				return game_entity
	Log.warn("Could not determine current_game from scene", sfp)

func get_current_game_mode():
	var g = get_current_game({all=true})
	if g and g.is_game_mode():
		return g

## launch game ##########################################################

## Invoked from Dino Level in a non-managed game
func debug_register_current_game():
	var ent = get_current_game({all=true})
	if ent:
		Log.pr("Registering current game with fallback player entity: ", ent)
		P.setup_player(ent)
		var player_entity = Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER)
		P.set_player_entity(player_entity)

var _is_managed = false
func is_managed():
	# TODO how to support this without state/autoload/node
	return _is_managed

## For a passed game, load its main menu.
## If no menu set, start the game via restart_game
func launch(game: DinoGameEntity, opts={}):
	_is_managed = true
	P.setup_player(game)

	if game.get_main_menu() != null:
		Navi.nav_to(game.get_main_menu(), opts)
		return

	restart_game(opts)

func restart_game(opts=null):
	var game = get_current_game()
	if game:
		Log.warn("Cannot (re)start_game, no current game")
		return
	if opts == null:
		opts = {}

	Log.pr("Starting game", game.get_display_name())

	var	first_level = game.get_first_level_scene()
	if first_level:
		Navi.nav_to(first_level, opts)
		return

	Log.warn("DinoGameEntity missing 'first_level', cannot start", game)

## load main menu helper ##########################################################

# called from most pause menus to return to the game's main menu
# TODO drop and use navi? or move navi menu logic here?
func load_main_menu():
	Navi.nav_to_main_menu()
