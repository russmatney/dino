@tool
extends DinoGame

func _ready():
	pass
	# pause_menu_scene = load("res://src/spike/menus/PauseMenu.tscn")
	# main_menu_scene = load("res://src/spike/menus/MainMenu.tscn")

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/spike")

func should_spawn_player(scene):
	return not scene.scene_file_path.begins_with("res://src/spike/menus")

## player ##########################################################

var player_scene = preload("res://src/spike/player/Player.tscn")

func get_spawn_coords():
	# TODO consider non-global usage of Metro here
	return Metro.get_spawn_coords()

## zones ##########################################################

const zone_scenes = [
	# "res://src/spike/zones/Tutorial.tscn",
	]

## register ##########################################################

var first_zone

func register():
	register_menus()

	Debug.pr("Registering Spike Zones")
	Hotel.add_root_group(Metro.zones_group)

	for sfp in zone_scenes:
		Hotel.book(sfp)

	# if first_zone == null:
	# 	first_zone = zone_scenes[0]

	var zones = Hotel.query({"group": Metro.zones_group})

	Debug.pr("Spike registered", len(zones), "zones and first zone ", first_zone)

## start ##########################################################

func start():
	Debug.prn("Starting Spike!")

	# TODO pull from saved game?
	Metro.load_zone(first_zone)

## Called to trigger a world update after the player is loaded or removed
func update_world():
	# TODO consider non-global usage of Metro here
	Metro.update_zone()
