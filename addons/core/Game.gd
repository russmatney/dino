@tool
extends Node

func all_game_entities():
	var ent = Pandora.get_entity(DinoGameEntityIds.DOTHOP)
	return Pandora.get_all_entities(Pandora.get_category(ent._category_id))

func game_for_entity(ent: DinoGameEntity):
	var singleton = ent.get_singleton()
	if singleton == null:
		Debug.warn("No singleton found for game_entity", ent)
		return

	var game = singleton.new()
	# TODO remove? this is also set in dinogame.enter_tree
	game.game_entity = ent
	var game_name = singleton.resource_path.get_basename().get_file()
	if Engine.has_singleton(game_name):
		return Engine.get_singleton(game_name)
	Engine.register_singleton(game_name, game)
	return game

## ready ##########################################################

func _ready():
	player_found.connect(_on_player_found)
	player_ready.connect(_find_player)
	_find_player()

	Navi.new_scene_instanced.connect(_on_new_scene_instanced)


## games ##########################################################

func game_entity_for_scene(scene):
	var gs = all_game_entities().filter(func(g): return g and g.manages_scene(scene))
	if gs.size() == 1:
		return gs[0]
	elif gs.size() == 0:
		Debug.warn("No game found to manage scene", scene, scene.scene_file_path)
	else:
		Debug.warn("Multiple games manage scene", scene, scene.scene_file_path, gs)

func set_current_game_for_scene(scene):
	var ent = game_entity_for_scene(scene)
	if ent:
		set_current_game_for_ent(ent)

func set_current_game_for_ent(ent):
	var game = game_for_entity(ent)
	if game:
		register_current_game(game)

func ensure_current_game():
	if current_game:
		var current_scene = get_tree().current_scene
		if current_scene and "scene_file_path" in current_scene:
			if current_scene.scene_file_path.begins_with("res://src/dino"):
				return
			set_current_game_for_scene(current_scene)

	if not current_game:
		Debug.warn("Failed to ensure current_game!")

func reset_current_game():
	current_game = null
	ensure_current_game()

## game lifecycle ##########################################################


var current_game: DinoGame

var is_managed: bool = false

func register_current_game(game):
	Debug.pr("Registering current game", game)
	current_game = game
	game.register()

# TODO does this sometimes restart the wrong game?
func restart_game(game=null, opts=null):
	remove_player()
	Navi.resume()  # ensure unpaused
	# indicate that we are not in dev-mode
	is_managed = true

	# TODO support a passed game_entity and/or game_ent_id
	if game:
		register_current_game(game)

	if not current_game:
		ensure_current_game()
	if not current_game:
		return
	if opts == null:
		opts = {}
	current_game.start(opts)


## game menus ##########################################################

# TODO where is this called?
func load_main_menu(game=null):
	if game == null:
		# reset current game _before_ setting
		reset_current_game()
		game = current_game
	if game and game.game_entity.get_main_menu() != null:
		# maybe we hide menus on every Navi.nav_to ?
		Navi.hide_menus()
		Navi.nav_to(game.game_entity.get_main_menu())
		return

	Debug.warn("No main_menu in game_entity, naving to fallback main menu.")
	Navi.nav_to_main_menu()

## For a passed game, load it's main menu. If none is set, start it via restart_game
func nav_to_game_menu_or_start(game_or_entity):
	var game
	if game_or_entity is DinoGameEntity:
		game = game_for_entity(game_or_entity)
	else:
		game = game_or_entity

	# be sure to register/update Game.current_game here!
	# could rely on manages_scene via reset_current_game,
	# but we'd have to wait for the menu/game scene to load
	register_current_game(game)

	if game.game_entity.get_main_menu() != null:
		# is this hide still necessary?
		Navi.hide_menus()
		Navi.nav_to(game.game_entity.get_main_menu())
		return

	restart_game(game)

## player ##########################################################

# TODO maybe better to let the zones respawn the player?
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
		Navi.current_scene.remove_child(p)
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
		Debug.err("No spawn coords found when respawning player")

	player.ready.connect(func(): player_ready.emit(player))

	if setup_fn != null:
		setup_fn.call(player)

	if current_game != null:
		current_game.on_player_spawned(player)

	# NOTE this is deferred
	Navi.add_child_to_current(player)
	player.ready.connect(func():
		if current_game != null:
			Debug.pr("_respawn_player updating world", player, player.global_position)
			current_game.update_world())

	spawning = false

func respawn_coords():
	if current_game and current_game.has_method("get_spawn_coords"):
		return current_game.get_spawn_coords()

	# TODO better game-independent respawn logic
	# probably via player_spawn_points group
	# collect nodes in groups
	# apply some kind of sort
	# return first preferred global position

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
