@tool
extends Node

## vars ##########################################################

const player_group = "player"

signal player_ready

# some of these states might be problemmatic as an autoload
# we might want to manage more than one player at once
var player
var player_scene
var player_entity

var player_type: DinoData.GameType

## player_scene #################################################

# If the game specifies a player_scene, set that.
# Otherwise, set the player type based on the game's player_type
func setup_player(game: DinoGameEntity):
	var ps = game.get_player_scene()
	if ps:
		player_scene = ps
		return
	# no player on current game? be sure to clear the player_scene!
	clear_player_scene()

	var typ = game.get_player_type()
	set_player_type(DinoData.to_game_type(typ))

func clear_player_scene():
	player_scene = null

func set_player_entity(ent):
	player_entity = ent
	# do more get_player_scene logic here?

func set_player_type(type: DinoData.GameType):
	player_type = type
	# do more get_player_scene logic here?

func get_player_scene():
	if player_scene:
		return player_scene

	var p_scene
	if player_entity != null and player_type != null:
		p_scene = player_entity.get_player_scene(player_type)

	if p_scene != null:
		return p_scene

	Log.warn("Player scene not found, using debug falling backs")
	if Dino.is_debug_mode():
		set_player_type(DinoData.GameType.SideScroller)
		set_player_entity(Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER))
		p_scene = player_entity.get_sidescroller_scene()
		return p_scene

## get player #################################################

func get_player():
	if player and is_instance_valid(player):
		return player

	# useful for gyms that run with an existing player
	var ps = get_tree().get_nodes_in_group(player_group)
	if len(ps) > 1:
		Log.warn("found multiple in player_group: ", player_group, ps)
	if len(ps) > 0:
		player = ps[0]
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

	Log.pr("Spawning new player", opts)

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

	var p_scene = opts.get("player_scene", get_player_scene())
	if p_scene == null:
		Log.err("Could not determine player_scene, cannot respawn")
		spawning = false
		return
	if p_scene is String:
		p_scene = load(p_scene)

	player = p_scene.instantiate()

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
