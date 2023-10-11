@tool
extends DinoGame

## player ##########################################################

func get_spawn_coords():
	return Metro.get_spawn_coords()

## register ##########################################################

var first_zone

func register():
	register_menus()

	if first_zone == null:
		first_zone = SpikeData.zone_scenes[0]

## start ##########################################################

func start(_opts={}):
	Debug.prn("Starting Spike!")

	Metro.load_zone(first_zone)

func update_world():
	Metro.update_zone()
