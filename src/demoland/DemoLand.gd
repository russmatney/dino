@tool
extends DinoGame

## zones #########################################################

const demoland_zones = [
	"res://src/demoland/zones/area01/Area01.tscn",
	"res://src/demoland/zones/area02/Area02.tscn",
	"res://src/demoland/zones/Area03.tscn",
	"res://src/demoland/zones/Area04.tscn",
	"res://src/demoland/zones/Area05.tscn",
	"res://src/demoland/zones/Area06PurpleStone.tscn",
	"res://src/demoland/zones/Area07GrassyCave.tscn",
	"res://src/demoland/zones/Area08AllTheThings.tscn",
	]

## register #########################################################

var first_zone

func register():
	register_menus()

	Debug.pr("Registering DemoLand Zones")
	Hotel.add_root_group(Metro.zones_group)

	for sfp in demoland_zones:
		Hotel.book(sfp)

	if first_zone == null:
		first_zone = demoland_zones[0]

	var zones = Hotel.query({"group": Metro.zones_group})

	Debug.pr("DemoLand registered", len(zones), "zones and first zone ", first_zone)

## player #########################################################

var player_scene = preload("res://src/hatbot/player/Player.tscn")

func get_player_scene():
	return player_scene

func get_spawn_coords():
	# TODO consider non-global usage of Metro here
	return Metro.get_spawn_coords()

## start #########################################################

func start(_opts={}):
	Debug.prn("Starting DemoLand!")

	# TODO pull from saved game?
	Metro.load_zone(first_zone)

## Called to trigger a world update after the player is loaded or removed
func update_world():
	# TODO consider non-global usage of Metro here
	Metro.update_zone()
