@tool
extends Node

###########################################################
# ready

func _ready():
	Debug.prn("Game autoload ready")

	player_found.connect(_on_player_found)
	player_ready.connect(_find_player)
	_find_player()

	Navi.new_scene_instanced.connect(_on_new_scene_instanced)

	# makes lots of things work just b/c (e.g. menus)
	# ensure_current_game()

###########################################################
# handling current_game (for dev-mode), could live elsewhere

# NOTE these need to auto-load BEFORE Game.gd
var games = [HatBot, DemoLand, DungeonCrawler, Ghosts, Herd, SuperElevatorLevel]


func game_for_scene(scene):
	var gs = games.filter(func(g): return g and g.manages_scene(scene))
	if gs.size() == 1:
		return gs[0]
	elif gs.size() == 0:
		Debug.warn("No game found to manage scene", scene, scene.scene_file_path)
	else:
		Debug.warn("Multiple games manage scene", scene, scene.scene_file_path, gs)

func set_current_game_for_scene(scene):
	var g = game_for_scene(scene)
	if g:
		register_current_game(g)

func ensure_current_game():
	if not current_game:
		var current_scene = get_tree().current_scene
		if current_scene and "scene_file_path" in current_scene:
			Debug.pr("No current_game, setting with current scene", current_scene)
			set_current_game_for_scene(current_scene)

	if not current_game:
		Debug.warn("Failed to ensure current_game!")

###########################################################
# game lifecycle

var current_game: DinoGame

var is_managed: bool = false

func register_current_game(game):
	Debug.pr("Registering current game", game)
	current_game = game
	game.register()

func restart_game(game):
	# indicate that we are not in dev-mode
	is_managed = true

	if game:
		register_current_game(game)

	if not current_game:
		Debug.err("No current_game set")
		return
	current_game.start()


###########################################################
# player

# TODO maybe better to let the zones respawn the player?
func _on_new_scene_instanced(scene):
	if current_game and current_game.manages_scene(scene):
		if current_game.should_spawn_player(scene):
			if not player and not spawning:
				Debug.prn("respawning player after new scene instanced")
				respawn_player()


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
		Debug.pr("found player: ", player)
	else:
		# too noisy, and corrected later on after startup
		# Debug.warn("could not find player, zero in player_group: ", player_group)
		return

	player_found.emit(player)

func _on_player_found(p):
	Debug.prn("Game.player found:", p)
	Hood.notif("Found player", p)
	if current_game:
		current_game.update_world()

var spawning = false
func respawn_player(opts={}):
	if current_game == null:
		Debug.warn("No current_game, can't spawn (or respawn) player")
		return
	if current_game.get_player_scene() == null:
		Debug.warn("current_game has no player_scene, can't respawn player", current_game)
		return

	spawning = true
	if player:
		var p = player
		player = null
		if p and is_instance_valid(p):
			Navi.current_scene.remove_child(p)
		current_game.update_world()
		if p and is_instance_valid(p):
			p.name = "DeadPlayer"
			p.queue_free()

	# defer to let player free safely
	_respawn_player.call_deferred(opts)

func _respawn_player(opts={}):
	var player_died = opts.get("player_died", false)
	var spawn_coords = opts.get("spawn_coords")
	if not spawn_coords:
		var coords_fn = opts.get("spawn_coords_fn", respawn_coords)
		spawn_coords = coords_fn.call()

	player = current_game.get_player_scene().instantiate()
	if not spawn_coords == null:
		player.position = spawn_coords
	else:
		Debug.err("No spawn coords found when respawning player")

	player.ready.connect(func(): player_ready.emit(player))

	# check in new player health
	# here we pass the data ourselves to not overwrite other fields (powerups)
	if player_died:
		# TODO some kind of initial_data() or reset() function for player data
		# note that death/travel maintains some things that restart_game might clear
		Hotel.check_in(player, {health=player.max_health})

	current_game.on_player_spawned(player)

	Navi.add_child_to_current(player)
	current_game.update_world()
	spawning = false

func respawn_coords():
	if current_game.has_method("get_spawn_coords"):
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



###########################################################
# dev helper functions

func maybe_spawn_player(opts={}):
	if not is_managed and not Engine.is_editor_hint() and player == null and not spawning:
		Debug.pr("Unmanaged game, player is null, spawning a new one", opts)
		ensure_current_game()
		respawn_player(opts)
