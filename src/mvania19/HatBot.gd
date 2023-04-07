@tool
extends DinoGame

###########################################################
# hatbot data

enum Powerup { Sword, DoubleJump, Climb, Read }
var all_powerups = [Powerup.Sword, Powerup.DoubleJump, Powerup.Climb]

###########################################################
# hatbot zones

const demoland_zone_scenes = [
	"res://src/mvania19/maps/demoland/area01/Area01.tscn",
	"res://src/mvania19/maps/demoland/area02/Area02.tscn",
	"res://src/mvania19/maps/demoland/area03/Area03.tscn",
	"res://src/mvania19/maps/demoland/area04/Area04.tscn",
	"res://src/mvania19/maps/demoland/area05snow/Area05.tscn",
	"res://src/mvania19/maps/demoland/area06purplestone/Area06PurpleStone.tscn",
	"res://src/mvania19/maps/demoland/area07grassycave/Area07GrassyCave.tscn",
	"res://src/mvania19/maps/demoland/area08allthethings/Area08AllTheThings.tscn",
	]

const hatbot_zone_scenes = [
	"res://src/mvania19/maps/hatbot/LevelZero.tscn",
	"res://src/mvania19/maps/hatbot/TheLandingSite.tscn",
	"res://src/mvania19/maps/hatbot/Simulation.tscn",
	"res://src/mvania19/maps/hatbot/TheKingdom.tscn",
	"res://src/mvania19/maps/hatbot/Volcano.tscn",
	]

###########################################################
# register

func manages_scene(scene_or_path):
	if scene_or_path is String:
		return scene_or_path in hatbot_zone_scenes
	return scene_or_path.scene_file_path in hatbot_zone_scenes

var first_zone

func register():
	Debug.pr("Registering HatBot Zones")

	# TODO include game ('hatbot') on hatbot zones, rooms, entities
	# TODO filter by game in hotel queries
	for sfp in hatbot_zone_scenes:
		Hotel.book(sfp)

	if first_zone == null:
		first_zone = hatbot_zone_scenes[0]

	var zones = Hotel.query({"group": "metro_zones"})

	Debug.pr("HatBot registered", len(zones), "zones and first zone ", first_zone)

###########################################################
# player

var player_scene = preload("res://src/mvania19/player/Monster.tscn")

func get_player_scene():
	return player_scene

func get_spawn_coords():
	# TODO consider non-global usage of Metro here
	return Metro.get_spawn_coords()

###########################################################
# start

func start():
	Debug.prn("Starting HatBot!")

	# TODO pull from saved game?
	Metro.load_zone(first_zone)

## Called to trigger a world update after the player is loaded or removed
func update_world():
	# TODO consider non-global usage of Metro here
	Metro.update_zone()
