@tool
extends Node

## vars ##########################################################

var current_game: DinoGame
var is_managed: bool = false
var is_in_game_mode: bool = false

## ready ##########################################################

func _ready():
	player_found.connect(_on_player_found)
	player_ready.connect(_find_player)
	_find_player()

	Navi.new_scene_instanced.connect(_on_new_scene_instanced)

## game entities ##########################################################

func all_game_entities():
	var ent = Pandora.get_entity(DinoGameEntityIds.DOTHOP)
	return Pandora.get_all_entities(Pandora.get_category(ent._category_id))\
		.filter(func(ent): return ent.is_enabled())

func game_for_entity(ent: DinoGameEntity):
	var singleton = ent.get_singleton()
	var game
	if singleton == null:
		# TODO combine DinoGame and DinoGameEntity (i.e. drop dinogame, move funcs to dinogameentity, adjust naming)
		game = DinoGame.new()
	else:
		game = singleton.new() # should inherit from dino game
	game.game_entity = ent
	return game

func game_entity_for_scene(scene):
	var gs = all_game_entities().filter(func(g): return g and g.manages_scene(scene))
	if gs.size() == 1:
		return gs[0]
	elif gs.size() == 0:
		Debug.warn("No game found to manage scene", scene, scene.scene_file_path)
	else:
		Debug.warn("Multiple games manage scene", scene, scene.scene_file_path, gs)

## current game ##########################################################

func set_current_game_for_scene(scene):
	var ent = game_entity_for_scene(scene)
	if ent:
		set_current_game_for_ent(ent)

func set_current_game_for_ent(ent):
	var game = game_for_entity(ent)
	if game and is_instance_valid(game):
		register_current_game(game)

func ensure_current_game():
	if not current_game:
		var current_scene = get_tree().current_scene
		if current_scene and "scene_file_path" in current_scene:
			set_current_game_for_scene(current_scene)

	if not current_game:
		Debug.warn("Failed to ensure current_game in scene:", get_tree().current_scene)

func reset_current_game():
	if current_game != null and is_instance_valid(current_game):
		current_game.cleanup()
		# free game singletons, update engine.singletons, re-create singletons from dino-game-entity?
		# current_game.queue_free()
		current_game = null
	ensure_current_game()

func register_current_game(game):
	if game == null or not is_instance_valid(game):
		Debug.warn("Attempted to register invalid game, aborting", game)
		return

	if game is DinoGameEntity:
		game = game_for_entity(game)

	if current_game != null and current_game != game:
		# remove player before clearing current_game
		remove_player()
		current_game.cleanup()
		# free game singletons, update engine.singletons, re-create singletons from dino-game-entity?
		# current_game.queue_free()
		Debug.pr("Waiting for cleanup: ", current_game.game_entity.get_display_name())
		await get_tree().create_timer(0.2).timeout
	Debug.pr("Registering game: ", game.game_entity.get_display_name())
	current_game = game
	current_game.register()

## restart game ##########################################################

func launch_in_game_mode(mode_node, entity, opts: Dictionary={}) -> Node2D:
	if not current_game:
		ensure_current_game()
	# TODO move to static Game.gd, pass known DinoGameEntitys/ids around
	if not current_game.game_entity.is_game_mode():
		Debug.warn("launch_in_game_mode called from a non-mode DinoGame", current_game, ". Abort!")
		return
	Debug.pr("Launching game in mode:", entity.get_display_name(), current_game.game_entity.get_display_name())

	# won't this clear the current game-mode?
	var game = game_for_entity(entity)

	Navi.resume() # remove if not needed

	is_managed = true
	is_in_game_mode = true

	var scene = entity.get_first_level_scene()
	var fl_node = scene.instantiate()
	if fl_node.has_method("set_game_opts"):
		fl_node.set_game_opts(opts)
	elif len(opts) > 0:
		Debug.warn("first_level node does not support 'set_game_opts', dropping passed opts", entity.get_display_name(), opts)

	return fl_node

func restart_game(opts=null):
	Navi.resume()  # ensure unpaused
	# indicate that we are not in dev-mode
	is_managed = true

	if not current_game:
		ensure_current_game()
	if not current_game:
		Debug.warn("Cannot restart_game, no current game")
		return
	if opts == null:
		opts = {}

	Debug.pr("Starting game", current_game.game_entity.get_display_name())
	current_game.start(opts)

## launch game ######################################################

## For a passed game, load it's main menu. If no menu set, start the game via restart_game
func launch(game_entity):
	var game = game_for_entity(game_entity)
	if game == null or not is_instance_valid(game):
		Debug.warn("No valid game found for entity, aborting launch", game_entity)
		return

	register_current_game(game)

	if game.game_entity.get_main_menu() != null:
		Navi.nav_to(game.game_entity.get_main_menu())
		return
	Debug.pr("no menu for game, launching!", game, game.game_entity, game.game_entity.get_main_menu())

	restart_game()

## load game menu ##########################################################

# called from most pause menus to return to the game's main menu
func load_main_menu():
	reset_current_game()
	if current_game and current_game.game_entity.get_main_menu() != null:
		Navi.nav_to(current_game.game_entity.get_main_menu())
		return

	Debug.warn("No main_menu in game_entity, naving to fallback main menu.")
	Navi.nav_to_main_menu()

## player ##########################################################

# maybe better to let the zones respawn the player?
func _on_new_scene_instanced(scene):
	if current_game and current_game.game_entity.manages_scene(scene):
		if current_game.game_entity.should_spawn_player(scene):
			if not player and not spawning:
				# defer to let the scene bring it's own player first
				maybe_spawn_player.call_deferred({skip_managed_check=true})


signal player_found(player)
signal player_ready(player)

var player
var player_group = "player"

func _find_player(p=null):
	if p:
		player = p

	if player:
		player_found.emit(player)
		return

	var ps = get_tree().get_nodes_in_group(player_group)

	if len(ps) > 1:
		Debug.warn("found multiple in player_group: ", player_group, ps)

	if len(ps) > 0:
		player = ps[0]
	else:
		# too noisy, and corrected later on after startup
		# Debug.warn("could not find player, zero in player_group: ", player_group)
		return

	player_found.emit(player)

func _on_player_found(_p):
	pass

func remove_player():
	var p = player
	player = null
	if p and is_instance_valid(p):
		get_tree().current_scene.remove_child(p)
	if current_game:
		current_game.update_world()
	if p and is_instance_valid(p):
		p.name = "DeadPlayer"
		p.queue_free()

var spawning = false
func respawn_player(opts={}):
	if opts.get("player_scene") == null:
		if current_game == null:
			Debug.warn("No current_game, can't spawn (or respawn) player")
			return
		elif current_game.game_entity.get_player_scene() == null:
			Debug.warn("current_game has no player_scene, can't respawn player", current_game)
			return

	spawning = true
	if player:
		Debug.pr("Respawn found player, will remove")
		remove_player()

	# defer to let player free safely
	_respawn_player.call_deferred(opts)

func _respawn_player(opts={}):
	var setup_fn = opts.get("setup_fn")
	var spawn_coords = opts.get("spawn_coords")
	if not spawn_coords:
		var coords_fn = opts.get("spawn_coords_fn", respawn_coords)
		if coords_fn.is_valid():
			spawn_coords = coords_fn.call()

	var player_scene = opts.get("player_scene")
	if player_scene == null and current_game != null:
		player_scene = current_game.game_entity.get_player_scene()
	if player_scene == null:
		Debug.err("Could not determine player_scene, cannot respawn")
		spawning = false
		return
	player = player_scene.instantiate()
	if not spawn_coords == null:
		player.position = spawn_coords
	else:
		Debug.warn("No spawn coords found when respawning player")

	player.ready.connect(func(): player_ready.emit(player))

	if setup_fn != null:
		setup_fn.call(player)

	if current_game != null:
		current_game.on_player_spawned(player)

	get_tree().current_scene.add_child.call_deferred(player)
	player.ready.connect(func():
		if current_game != null:
			current_game.update_world())

	spawning = false

func respawn_coords():
	if current_game and current_game.has_method("get_spawn_coords"):
		return current_game.get_spawn_coords()

	var psp = Util.first_node_in_group("player_spawn_points")
	if psp:
		return psp.global_position
	var elevator = Util.first_node_in_group("elevator")
	if elevator:
		return elevator.global_position


## dev helper functions ##########################################################

func maybe_spawn_player(opts={}):
	# we maybe don't care for this managed check anymore
	if (not is_managed or opts.get("skip_managed_check")) \
		and not Engine.is_editor_hint() \
		and player == null and not spawning:
		ensure_current_game()

		# the player might already be in the scene
		_find_player()

		if player == null:
			Debug.pr("Player is null, spawning a new one", opts)
			respawn_player(opts)
