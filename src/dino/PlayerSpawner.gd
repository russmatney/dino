extends Node
class_name PlayerSpawner

@export var genre: DinoData.Genre

func _ready():
	if get_parent() == get_tree().current_scene:
		Log.info("Parent is scene root, will ensure a player")
		var player = U.first_node_in_group(self, "player")
		if not player:
			Dino.ensure_player_setup({genre=genre})
			Dino.spawn_player()
		else:
			Log.info("Found player, skipping spawn")

		var cam = get_parent().get_node_or_null("Camera2D")
		if not cam:
			cam = Camera2D.new()
			var host = PhantomCameraHost.new()
			cam.add_child(host)
			get_parent().add_child.call_deferred(cam)
		else:
			Log.info("Found camera, skipping spawn")
