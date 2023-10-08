@tool
extends DinoGame

## zones ##########################################################

const zone_scenes = [
	"res://src/hatbot/zones/LevelZero.tscn",
	"res://src/hatbot/zones/TheLandingSite.tscn",
	"res://src/hatbot/zones/Simulation.tscn",
	"res://src/hatbot/zones/TheKingdom.tscn",
	"res://src/hatbot/zones/Volcano.tscn",
	]


## register ##########################################################

var first_zone

func register():
	register_menus()

	Debug.pr("Registering HatBot Zones")
	Hotel.add_root_group(Metro.zones_group)

	# TODO include game ('hatbot') on hatbot zones, rooms, entities
	# TODO filter by game in hotel queries
	for sfp in zone_scenes:
		Hotel.book(sfp)

	if first_zone == null:
		first_zone = zone_scenes[0]

	var zones = Hotel.query({"group": Metro.zones_group})

	Debug.pr("HatBot registered", len(zones), "zones and first zone ", first_zone)


## player ##########################################################

var player_scene = preload("res://src/hatbot/player/Player.tscn")

func get_spawn_coords():
	# TODO consider non-global usage of Metro here
	return Metro.get_spawn_coords()


## start ##########################################################

func start(_opts={}):
	Debug.prn("Starting HatBot!")

	# TODO pull from saved game?
	Metro.load_zone(first_zone)

## Called to trigger a world update after the player is loaded or removed
func update_world():
	# TODO consider non-global usage of Metro here
	Metro.update_zone()
