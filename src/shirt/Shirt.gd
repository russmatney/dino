@tool
extends DinoGame

var player_scene = preload("res://src/shirt/player/Player.tscn")

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/shirt")
