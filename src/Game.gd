@tool
extends Node

###########################################################
# ready

func _ready():
	Debug.prn("Game autoload ready")

	# TODO flip dependency and logic with Hood
	Hood.found_player.connect(_on_player_found)
	if Hood.player:
		_on_player_found(Hood.player)

	Navi.new_scene_instanced.connect(_on_new_scene_instanced)

###########################################################
# handling current_game (for dev-mode), could live elsewhere

# NOTE these need to auto-load BEFORE Game.gd
var games = [HatBot, DemoLand, DungeonCrawler]

func game_for_scene(sfp):
	Debug.log("games", games)
	var gs = games.filter(func(g): return g and g.manages_scene(sfp))
	if gs.size() == 1:
		return gs[0]
	elif gs.size() == 0:
		Debug.warn("No game found to manage scene", sfp)
	else:
		Debug.warn("Multiple games manage scene", sfp, gs)

func set_current_game_for_scene(sfp):
	var g = game_for_scene(sfp)
	if g:
		register_current_game(g)

func ensure_current_game(sfp=null):
	if not current_game:
		Debug.pr("No current_game, setting with passed sfp", sfp)
		set_current_game_for_scene(sfp)
	if not current_game:
		Debug.warn("No current_game!")
		# TODO get cute about looking one up based on the scene tree or autoloads?

###########################################################
# game lifecycle

var current_game: DinoGame

var is_managed: bool = false

func register_current_game(game):
	Debug.pr("Registering current game", game)
	current_game = game
	game.register()

func restart_game(game=null):
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
		if not player and not spawning:
			Debug.prn("respawning player after new scene instanced")
			respawn_player()

var player

signal player_found(player)

func _on_player_found(p):
	Debug.prn("Game.player found:", p)
	if not player:
		player = p

	player_found.emit(player)
	if current_game:
		current_game.update_world()

var spawning = false
func respawn_player(opts={}):
	if not current_game:
		Debug.warn("No current_game, can't respawn player")
		return
	if not current_game.get_player_scene():
		Debug.warn("current_game has not player_scene, can't respawn player", current_game)
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

	# check in new player health
	# here we pass the data ourselves to not overwrite other fields (powerups)
	if player_died:
		# TODO some kind of initial_data() or reset() function for player data
		# note that death/travel maintains some things that restart_game might clear
		Hotel.check_in(player, {health=player.max_health})

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
		respawn_player(opts)
