@tool
extends Node

## vars ##########################################################

var player
var player_scene
var player_group = "player"

## player_scene #################################################

# set a cached player_scene to support simple respawn_player() calls
func set_player_scene(game):
	var ps = game.get_player_scene()
	if ps:
		player_scene = ps

## get player #################################################

func get_player():
	if player and is_instance_valid(player):
		return player

	var ps = get_tree().get_nodes_in_group(player_group)

	if len(ps) > 1:
		Log.warn("found multiple in player_group: ", player_group, ps)

	if len(ps) > 0:
		player = ps[0]
	else:
		# too noisy, and corrected later on after startup
		# Log.warn("could not find player, zero in player_group: ", player_group)
		return

	return player

## remove player #################################################

func remove_player():
	var p = player
	player = null
	if p and is_instance_valid(p):
		get_tree().current_scene.remove_child(p)
	if p and is_instance_valid(p):
		p.name = "DeadPlayer"
		p.queue_free()

## respawn player #################################################

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
			var game = Game.get_current_game()

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
	var setup = opts.get("setup")
	var spawn_coords = opts.get("spawn_coords")

	var p_scene = opts.get("player_scene")
	if p_scene == null:
		Log.err("Could not determine player_scene, cannot respawn")
		spawning = false
		return
	if p_scene is String:
		p_scene = load(p_scene)

	player_scene = p_scene
	player = player_scene.instantiate()

	if spawn_coords != null:
		player.position = spawn_coords
	else:
		Log.warn("No spawn coords found when respawning player")

	if setup != null:
		setup.call(player)

	get_tree().current_scene.add_child.call_deferred(player)

	spawning = false

## respawn_coords ################################################

func respawn_coords():
	var psp = U.first_node_in_group(self, "player_spawn_points")
	if psp:
		return psp.global_position
	var elevator = U.first_node_in_group(self, "elevator")
	if elevator:
		return elevator.global_position
