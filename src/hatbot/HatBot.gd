@tool
extends DinoGame

func _ready():
	# TODO hatbot should get it's own pause menu with a map
	pause_menu_scene = load("res://src/mountain/menus/PauseMenu.tscn")
	main_menu_scene = load("res://src/hatbot/menus/MainMenu.tscn")

## data ##########################################################


enum Powerup { Sword, DoubleJump, Climb, Read }
var all_powerups = [Powerup.Sword, Powerup.DoubleJump, Powerup.Climb]


## zones ##########################################################

const zone_scenes = [
	"res://src/hatbot/zones/LevelZero.tscn",
	"res://src/hatbot/zones/TheLandingSite.tscn",
	"res://src/hatbot/zones/Simulation.tscn",
	"res://src/hatbot/zones/TheKingdom.tscn",
	"res://src/hatbot/zones/Volcano.tscn",
	]


## register ##########################################################

func manages_scene(scene):
	return scene.scene_file_path in zone_scenes

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

# var player_scene = preload("res://src/hatbot/player/Monster.tscn")
var player_scene = preload("res://src/hatbot/player/Player.tscn")

func get_spawn_coords():
	# TODO consider non-global usage of Metro here
	return Metro.get_spawn_coords()


## start ##########################################################

func start():
	Debug.prn("Starting HatBot!")

	# TODO pull from saved game?
	Metro.load_zone(first_zone)

## Called to trigger a world update after the player is loaded or removed
func update_world():
	# TODO consider non-global usage of Metro here
	Metro.update_zone()
