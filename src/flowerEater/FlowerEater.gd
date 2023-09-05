@tool
extends DinoGame


func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/flowerEater")

func should_spawn_player(_scene):
	return false
