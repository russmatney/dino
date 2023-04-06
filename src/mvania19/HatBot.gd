@tool
extends DinoGame

###########################################################
# hatbot data

enum Powerup { Sword, DoubleJump, Climb, Read }
var all_powerups = [Powerup.Sword, Powerup.DoubleJump, Powerup.Climb]

###########################################################
# hatbot areas

const demoland_area_scenes = [
	"res://src/mvania19/maps/demoland/area01/Area01.tscn",
	"res://src/mvania19/maps/demoland/area02/Area02.tscn",
	"res://src/mvania19/maps/demoland/area03/Area03.tscn",
	"res://src/mvania19/maps/demoland/area04/Area04.tscn",
	"res://src/mvania19/maps/demoland/area05snow/Area05.tscn",
	"res://src/mvania19/maps/demoland/area06purplestone/Area06PurpleStone.tscn",
	"res://src/mvania19/maps/demoland/area07grassycave/Area07GrassyCave.tscn",
	"res://src/mvania19/maps/demoland/area08allthethings/Area08AllTheThings.tscn",
	]

const hatbot_area_scenes = [
	"res://src/mvania19/maps/hatbot/LevelZero.tscn",
	"res://src/mvania19/maps/hatbot/TheLandingSite.tscn",
	"res://src/mvania19/maps/hatbot/Simulation.tscn",
	"res://src/mvania19/maps/hatbot/TheKingdom.tscn",
	"res://src/mvania19/maps/hatbot/Volcano.tscn",
	]

## Returns true if the passed scene is managed by HatBot
func manages_scene(scene):
	return scene.scene_file_path in area_scenes

# var area_scenes = demoland_area_scenes
var area_scenes = hatbot_area_scenes
var first_area

# probably actually an areas/zones helper func
func register_areas():
	Debug.pr("Checking in HatBot Areas")

	if not first_area:
		first_area = area_scenes[0]

	for sfp in area_scenes:
		Hotel.book(sfp)

	var areas = Hotel.query({"group": "mvania_areas"})

	Debug.pr("HatBot registered", len(areas), "areas.")

###########################################################
# register

## Registers hatbot areas
func register():
	register_areas()

###########################################################
# player

var player_scene = preload("res://src/mvania19/player/Monster.tscn")

func get_player_scene():
	return player_scene

func get_spawn_coords():
	return MvaniaGame.get_spawn_coords()

###########################################################
# start

func start():
	Debug.prn("Starting HatBot!")

	# consider area selection logic
	# TODO pull from saved game?
	MvaniaGame.load_area(first_area)

## Called to trigger a world update after the player is loaded or removed
func update_world():
	MvaniaGame.update_rooms()
