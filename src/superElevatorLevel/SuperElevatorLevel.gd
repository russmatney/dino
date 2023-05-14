@tool
extends DinoGame

# TODO support player selection
var player_scene = preload("res://src/superElevatorLevel/players/PlayerOne.tscn")

func manages_scene(scene):
	var level_paths = levels.map(func(l): return l.resource_path)
	if scene.scene_file_path in level_paths:
		level_idx = level_paths.find(scene.scene_file_path)

	return scene.scene_file_path.begins_with("res://src/superElevatorLevel")

func register():
	pass

func on_player_spawned(player):
	player.died.connect(on_player_died.bind(player), CONNECT_ONE_SHOT)

func on_player_died(_player):
	Game.respawn_player.call_deferred({setup_fn=func(p):
		# restore player health
		Hotel.check_in(p, {health=p.initial_health})})

## levels ####################################################################

var levels = [
	preload("res://src/superElevatorLevel/levels/GroundFloor.tscn"),
	preload("res://src/superElevatorLevel/levels/Elevator.tscn"),
	preload("res://src/superElevatorLevel/levels/TheBoffice.tscn"),
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
