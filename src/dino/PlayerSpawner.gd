extends Node
class_name PlayerSpawner

func _ready():
	if get_parent() == get_tree().current_scene:
		Log.info("Parent is scene root, will ensure a player")
		var player = U.first_node_in_group(self, "player")
		if not player:
			Dino.ensure_player_setup()
			Dino.spawn_player()
		else:
			Log.info("Found player, skipping spawn")
