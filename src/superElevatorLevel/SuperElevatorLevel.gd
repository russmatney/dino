@tool
extends DinoGame

# TODO support player selection
var player_scene = preload("res://src/superElevatorLevel/players/PlayerOne.tscn")

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/superElevatorLevel")

func register():
	pass

func start():
	pass
