@tool
extends DinoGame

# NOTE needs update re: DinoGameEntity

######################################################
# manages scene

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/<game>")

func should_spawn_player(scene):
	return not scene.scene_file_path.begins_with("res://src/<game>/menus")

######################################################
# player

var player_scene = "res://src/<game>/player/Player.tscn"

func on_player_spawned(_player):
	pass

######################################################
# register

# register any static zones/scenes with Hotel
# register any menus with Navi
func register():
	main_menu_scene = "res://src/<game>/menus/MainMenu.tscn"

######################################################
# start

# load the first level, maybe load from a saved game
func start(_opts={}):
	pass

######################################################
# update world

# trigger any world update based on the player's position after player spawn/changes rooms
# (e.g. pausing/unpausing adjacent rooms)
func update_world():
	pass
