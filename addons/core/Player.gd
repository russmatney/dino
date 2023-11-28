@tool
extends Node

## vars ##########################################################

signal player_ready

var player
var fallback_player_scene
var player_scene
var player_entity
var player_group = "player"

enum PlayerType {SideScroller, TopDown, BeatEmUp}
var player_type: PlayerType

## player_scene #################################################

# setup player type and a fallback scene for the passed game entity
func setup_player(game: DinoGameEntity):
	var typ = game.get_player_type()
	if typ != null:
		match typ:
			"sidescroller": set_player_type(PlayerType.SideScroller)
			"topdown": set_player_type(PlayerType.TopDown)
			"beatemup": set_player_type(PlayerType.BeatEmUp)

	var ps = game.get_player_scene()
	if ps:
		fallback_player_scene = ps

func set_player_entity(ent):
	player_entity = ent
	# do more get_player_scene logic here?

func set_player_type(player_type: PlayerType):
	player_type = player_type
	# do more get_player_scene logic here?

func get_player_scene():
	# consider smthihng like:
	# var game = Game.get_current_game()

	var p_scene
	if player_entity != null and player_type != null:
		match player_type:
			PlayerType.SideScroller: p_scene = player_entity.get_sidescroller_scene()
			PlayerType.TopDown: p_scene = player_entity.get_topdown_scene()
			PlayerType.BeatEmUp: p_scene = player_entity.get_beatemup_scene()

	if p_scene != null:
		return p_scene
	Log.warn("No player scene found for player_entity and player_type", player_entity, player_type)

	if fallback_player_scene:
		return fallback_player_scene
	Log.pr("No fallback_player_scene set")

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
		p.get_parent().remove_child(p)
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
	# overwriting this is generally for debugging only
	if opts.get("player_scene") == null:
		if player_scene:
			# support reading a cached player_scene
			opts["player_scene"] = player_scene
		else:
			opts["player_scene"] = get_player_scene()

	spawning = true
	if player:
		Log.pr("Respawn found player, will remove")
		remove_player()

	_respawn_player.call_deferred(opts)

func _respawn_player(opts={}):
	var setup = opts.get("setup")
	var spawn_coords = opts.get("spawn_coords")
	var spawn_point
	if spawn_coords == null:
		spawn_point = get_spawn_point()
		if spawn_point:
			spawn_coords = spawn_point.global_position

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

	player.ready.connect(func(): player_ready.emit())

	if spawn_point:
		U.add_child_to_level(spawn_point, player)
	else:
		Log.warn("No spawn_point found, adding player to current_scene")
		get_tree().current_scene.add_child.call_deferred(player)

	spawning = false

## respawn_coords ################################################

func get_spawn_point():
	var psp = U.first_node_in_group(self, "player_spawn_points")
	if psp:
		return psp
	var elevator = U.first_node_in_group(self, "elevator")
	if elevator:
		return elevator
