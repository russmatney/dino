@tool
extends DinoGame

## player ##########################################################

func get_spawn_coords():
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

	if first_zone == null:
		first_zone = zone_scenes[0]

## start ##########################################################

func start(_opts={}):
	Debug.prn("Starting Shirt!")

	Metro.load_zone(first_zone)

## Called to trigger a world update after the player is loaded or removed
func update_world():
	Metro.update_zone()
