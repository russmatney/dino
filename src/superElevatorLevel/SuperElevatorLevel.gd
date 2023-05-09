@tool
extends DinoGame

var player_scene = preload("res://src/superElevatorLevel/players/Player.tscn")

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/superElevatorLevel")

func register():
	pass

func start():
	pass
