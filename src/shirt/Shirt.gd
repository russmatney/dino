@tool
extends DinoGame

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/shirt")

func should_spawn_player(scene):
	return not scene.scene_file_path.begins_with("res://src/shirt/menus")

## player ##########################################################

var player_scene = preload("res://src/shirt/player/Player.tscn")

func get_spawn_coords():
	# TODO consider non-global usage of Metro here
	return Metro.get_spawn_coords()

## zones ##########################################################

const zone_scenes = [
	"res://src/shirt/zones/CaveOne.tscn",
	"res://src/shirt/zones/ShrineOne.tscn",
	"res://src/shirt/zones/ShrineTwo.tscn",
	]

## register ##########################################################

var first_zone

func register():
	register_menus()

	Debug.pr("Registering Shirt Zones")
	Hotel.add_root_group(Metro.zones_group)

	for sfp in zone_scenes:
		Hotel.book(sfp)

	if first_zone == null:
		first_zone = zone_scenes[0]

	var zones = Hotel.query({"group": Metro.zones_group})

	Debug.pr("Shirt registered", len(zones), "zones and first zone ", first_zone)

## start ##########################################################

func start(_opts={}):
	Debug.prn("Starting Shirt!")

	# TODO pull from saved game?
	Metro.load_zone(first_zone)

## Called to trigger a world update after the player is loaded or removed
func update_world():
	# TODO consider non-global usage of Metro here
	Metro.update_zone()
