extends Position2D


export(PackedScene) var player_to_spawn
var fallback_player_scene = preload("res://src/players/TopDownPlayer.tscn")

func spawn_player(parent = null) -> KinematicBody2D:
	print("doing some spawning action")

	var player: KinematicBody2D
	if player_to_spawn:
		player = player_to_spawn.instance()
	else:
		player = fallback_player_scene.instance()

	if not player:
		print("could not create player instance")
		return null

	player.transform.origin = position

	# TODO defer this stuff
	if parent:
		parent.add_child(player)
	else:
		add_child(player)

	return player
