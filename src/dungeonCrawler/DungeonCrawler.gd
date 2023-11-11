@tool
extends DinoGame

###########################################################
# zones

const zones = [
	"res://src/dungeonCrawler/zones/TwoGeon.tscn",
	]

###########################################################
# register

var first_zone

func register():
	register_menus()

	if first_zone == null:
		first_zone = zones[0]

###########################################################
# player

func get_spawn_coords():
	return Metro.get_spawn_coords()

###########################################################
# start

func start(_opts={}):
	Log.prn("Starting DungeonCrawler!")
	Metro.load_zone(first_zone)

func update_world():
	Metro.update_zone()
