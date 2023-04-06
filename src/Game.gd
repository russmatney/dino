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

func _on_new_scene_instanced(scene):
	if current_game and current_game.manages_scene(scene):
		if not player and not spawning:
			respawn_player()

###########################################################
# player

var player
var player_scene

signal player_found(player)

func _on_player_found(p):
	Debug.prn("Game.player found", p)
	if not player:
		player = p

	player_found.emit(player)
	current_game.update_world()

## Register the player scene, so Game can spawn/respawn the player
func register_player_scene(p_scene):
	if not p_scene:
		Debug.err("Game found no player scene")
		return
	player_scene = p_scene
	Hotel.book(player_scene)

var spawning = false
func respawn_player(player_died=false):
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

	# defer to let player free safely?
	call_deferred("_respawn_player", player_died)

func _respawn_player(player_died=false):
	var spawn_coords = current_game.get_spawn_coords()

	player = player_scene.instantiate()
	if spawn_coords:
		player.position = spawn_coords
	else:
		Debug.err("No spawn coords found when respawning player")

	# check in new player health
	# here we pass the data ourselves to not overwrite other fields (powerups)
	if player_died:
		Hotel.check_in(player, {health=player.max_health})

	Navi.add_child_to_current(player)
	current_game.update_world()
	spawning = false


###########################################################
# dev helper functions

func maybe_spawn_player():
	if not managed_game and not Engine.is_editor_hint() and player == null and not spawning:
		Debug.pr("Unmanaged game, player is null, spawning")
		respawn_player()

###########################################################
# game lifecycle

# probably a DinoGame type
var current_game = HatBot

var managed_game: bool = false

func register(game):
	# make sure we get a player scene
	register_player_scene(game.player_scene)
	game.register()

func set_current_game(game):
	current_game = game

func restart_game(game=null):
	if game:
		current_game = game

	if not current_game:
		Debug.err("No current_game set")
		return

	managed_game = true
	register(current_game)
	current_game.start()
