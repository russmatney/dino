@tool
extends DinoGame

const zones = [
	"res://src/mountain/zones/TheMountain.tscn"
	]

######################################################
# manages scene

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/mountain")

func should_spawn_player(scene):
	return not scene.scene_file_path.begins_with("res://src/mountain/menus")

######################################################
# player

var player_scene = "res://src/mountain/player/Player.tscn"

func on_player_spawned(_player):
	pass

func get_spawn_coords():
	return Metro.get_spawn_coords()

######################################################
# register

func register():
	main_menu_scene = "res://src/mountain/menus/MainMenu.tscn"

	# required?
	Hotel.add_root_group(Metro.zones_group)

	for z in zones:
		Hotel.book(z)


######################################################
# start

func start():
	Metro.load_zone(zones[0])

######################################################
# update world

func update_world():
	Metro.update_zone()