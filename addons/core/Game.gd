@tool
extends Node

## vars ##########################################################

var is_managed: bool = false
var is_in_game_mode: bool = false

## ready ##########################################################

func _ready():
	player_ready.connect(_find_player)
	_find_player()

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

# set a cached player_scene to support simple respawn_player() calls
func set_player_scene(game):
	var ps = game.get_player_scene()
	if ps:
		player_scene = ps

# set player_scene, but do not register menus
func launch_in_game_mode(mode_node, game: DinoGameEntity, opts: Dictionary={}):
	Log.pr("Launching game", game.get_display_name(), "in mode node", mode_node)

	set_player_scene(game)

	is_managed = true
	is_in_game_mode = true

## For a passed game, load it's main menu. If no menu set, start the game via restart_game
func launch(game: DinoGameEntity):
	if game.get_main_menu() != null:
		Navi.nav_to(game.get_main_menu())
		return
	restart_game()

func restart_game(opts=null):
	Navi.resume()  # ensure unpaused
	# indicate that we are not in dev-mode
	is_managed = true

	var game = get_current_game()
	if game:
		Log.warn("Cannot (re)start_game, no current game")
		return
	if opts == null:
		opts = {}

	Log.pr("Starting game", game.get_display_name())

	register_menus(game)
	set_player_scene(game)

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

## player ##########################################################

signal player_found(player)
signal player_ready(player)

var player
var player_scene
var player_group = "player"

func _find_player(p=null):
	if p:
		player = p

	if player:
		player_found.emit(player)
		return

	var ps = get_tree().get_nodes_in_group(player_group)

	if len(ps) > 1:
		Log.warn("found multiple in player_group: ", player_group, ps)

	if len(ps) > 0:
		player = ps[0]
	else:
		# too noisy, and corrected later on after startup
		# Log.warn("could not find player, zero in player_group: ", player_group)
		return

	player_found.emit(player)

func remove_player():
	var p = player
	player = null
	if p and is_instance_valid(p):
		get_tree().current_scene.remove_child(p)
	if p and is_instance_valid(p):
		p.name = "DeadPlayer"
		p.queue_free()

var spawning = false
func respawn_player(opts={}):
	if spawning:
		Log.pr("player already spawning, skipping respawn_player")
		return

	Log.pr("Spawning new player")
	if opts.get("player_scene") == null:
		if player_scene:
			# support reading a cached player_scene
			opts["player_scene"] = player_scene
		else:
			var game = get_current_game()

			if game == null:
				Log.warn("No current_game, can't spawn (or respawn) player")
				return
			elif game.get_player_scene() == null:
				Log.warn("current_game has no player_scene, can't respawn player", game)
				return

			opts["player_scene"] = game.get_player_scene()

	spawning = true
	if player:
		Log.pr("Respawn found player, will remove")
		remove_player()

	_respawn_player.call_deferred(opts)

func _respawn_player(opts={}):
	var setup_fn = opts.get("setup_fn")
	var spawn_coords = opts.get("spawn_coords")
	if not spawn_coords:
		var coords_fn = opts.get("spawn_coords_fn", respawn_coords)
		if coords_fn.is_valid():
			spawn_coords = coords_fn.call()

	var p_scene = opts.get("player_scene")
	# TODO maybe get_current_game() here?
	if p_scene == null:
		Log.err("Could not determine player_scene, cannot respawn")
		spawning = false
		return
	if p_scene is String:
		p_scene = load(p_scene)
	player_scene = p_scene
	player = player_scene.instantiate()
	if not spawn_coords == null:
		player.position = spawn_coords
	else:
		Log.warn("No spawn coords found when respawning player")

	player.ready.connect(func(): player_ready.emit(player))

	if setup_fn != null:
		setup_fn.call(player)

	get_tree().current_scene.add_child.call_deferred(player)

	spawning = false

func respawn_coords():
	var psp = U.first_node_in_group(self, "player_spawn_points")
	if psp:
		return psp.global_position
	var elevator = U.first_node_in_group(self, "elevator")
	if elevator:
		return elevator.global_position

## dev helper functions ##########################################################

func maybe_spawn_player(opts={}):
	# we maybe don't care for this managed check anymore
	if (not is_managed or opts.get("skip_managed_check")) \
		and not Engine.is_editor_hint() \
		and player == null and not spawning:
		# the player might already be in the scene
		_find_player()

		if player == null:
			Log.pr("Player is null, spawning a new one", opts)
			respawn_player(opts)
	elif player != null:
		pass
		# Log.pr("player not null, ignoring maybe_spawn_player")
	elif spawning:
		pass
		# Log.pr("player spawning, ignoring maybe_spawn_player")
	elif is_managed:
		pass
		# Log.pr("game is managed, ignoring maybe_spawn_player")
	elif Engine.is_editor_hint():
		pass
		# Log.pr("in editor, ignoring maybe_spawn_player")
