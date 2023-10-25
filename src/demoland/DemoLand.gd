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

	if first_zone == null:
		first_zone = demoland_zones[0]

## player #########################################################

func get_spawn_coords():
	return Metro.get_spawn_coords()

## start #########################################################

func start(_opts={}):
	Debug.prn("Starting DemoLand!")

	Metro.load_zone(first_zone)

func update_world():
	Metro.update_zone()
