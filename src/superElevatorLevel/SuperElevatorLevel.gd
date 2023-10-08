@tool
extends DinoGame

## player ####################################################################

# TODO support player selection
func get_player_scene():
	return load("res://src/superElevatorLevel/players/PlayerOne.tscn")

func on_player_spawned(player):
	player.died.connect(on_player_died.bind(player), CONNECT_ONE_SHOT)

func on_player_died(_player):
	Game.respawn_player.call_deferred({setup_fn=func(p):
		# restore player health
		Hotel.check_in(p, {health=p.initial_health})})

## register ####################################################################

func register():
	register_menus()

# TODO manages scene used to set a level_idx here as a dev helper

## levels ####################################################################

var levels = [
	preload("res://src/superElevatorLevel/levels/GroundFloor.tscn"),
	preload("res://src/superElevatorLevel/levels/Elevator.tscn"),
	preload("res://src/superElevatorLevel/levels/TheBoffice.tscn"),
	]

var level_idx = 0

func start(_opts={}):
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
