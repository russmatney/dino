@tool
extends DinoGame

###########################################################
# zones

const zones = [
	"res://src/dungeonCrawler/zones/TwoGeon.tscn",
	]

###########################################################
# register

func manages_scene(scene_or_path):
	if scene_or_path is String:
		return scene_or_path in zones
	return scene_or_path.scene_file_path in zones

var first_zone

func register():
	Debug.pr("Registering DungeonCrawler Zones")

	for sfp in zones:
		Hotel.book(sfp)

	if first_zone == null:
		first_zone = zones[0]

	var zs = Hotel.query({"group": "metro_zones"})

	Debug.pr("DungeonCrawler registered", len(zs), "zones and first zone ", first_zone)

###########################################################
# player

var player_scene = preload("res://src/dungeonCrawler/player/Player.tscn")

func get_player_scene():
	return player_scene

func get_spawn_coords():
	# TODO consider non-global usage of Metro here
	return Metro.get_spawn_coords()

###########################################################
# start

func start():
	Debug.prn("Starting DungeonCrawler!")

	# TODO pull from saved game?
	Metro.load_zone(first_zone)

## Called to trigger a world update after the player is loaded or removed
func update_world():
	# TODO consider non-global usage of Metro here
	Metro.update_zone()