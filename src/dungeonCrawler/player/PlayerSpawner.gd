extends Marker2D

@export var player_to_spawn: PackedScene
var fallback_player_scene = preload("res://src/dungeonCrawler/player/Player.tscn")


func spawn_player(parent = null):
	var player
	if player_to_spawn:
		player = player_to_spawn.instantiate()
	else:
		player = fallback_player_scene.instantiate()

	if not player:
		Debug.pr("could not create player instance")
		return null

	player.transform.origin = position

	# TODO defer this stuff
	if parent:
		parent.add_child(player)
	else:
		add_child(player)

	return player
