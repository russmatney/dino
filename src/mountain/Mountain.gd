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

var player_scene = preload("res://src/mountain/player/Player.tscn")

func on_player_spawned(_player):
	pass

func get_spawn_coords():
	return Metro.get_spawn_coords()

######################################################
# register

func register():
	# look, two different menu mgmt systems!
	# TODO pick one pattern for this
	main_menu_scene = load("res://src/mountain/menus/MainMenu.tscn")
	Navi.set_pause_menu("res://src/mountain/menus/PauseMenu.tscn")

	# is this required anymore?
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
