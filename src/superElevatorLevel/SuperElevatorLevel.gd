@tool
extends DinoGame

# TODO support player selection
var player_scene = preload("res://src/superElevatorLevel/players/PlayerOne.tscn")

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/superElevatorLevel")

func register():
	pass

## levels ####################################################################

var levels = [
	preload("res://src/superElevatorLevel/levels/GroundFloor.tscn"),
	preload("res://src/superElevatorLevel/levels/Elevator.tscn"),
	# preload("res://src/superElevatorLevel/levels/Office.tscn"),
	]

var level_idx = 0

func start():
	level_idx = 0
	load_level()

func load_next_level():
	level_idx += 1
	load_level()

func reload_level():
	load_level()

func load_level():
	if level_idx >= len(levels):
		# TODO custom win screen
		Navi.show_win_menu()
		return

	var level = levels[level_idx]
	Navi.nav_to(level)
