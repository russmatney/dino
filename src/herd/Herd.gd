@tool
extends DinoGame

######################################################
# dino game api

var player_scene = preload("res://src/herd/player/Player.tscn")

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/herd")

######################################################
# level mgmt

var levels = [
	"res://src/herd/levels/LevelOne.tscn",
	"res://src/herd/levels/LevelTwo.tscn"
	]

func start():
	var first_level = levels[0]
	Navi.nav_to(first_level)
