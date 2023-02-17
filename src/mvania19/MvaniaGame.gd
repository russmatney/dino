@tool
extends Node


func prn(msg, msg2=null, msg3=null):
	if msg3:
		print("[MvaniaGame]: ", msg, msg2, msg3)
	elif msg2:
		print("[MvaniaGame]: ", msg, msg2)
	else:
		print("[MvaniaGame]: ", msg)

###########################################################
# ready

func _ready():
	prn("autoload ready")

###########################################################
# area DB

# TODO read from file
var area_db = {}

func persist_area(area):
	# TODO don't overwrite if exists?
	area_db[area.name] = {"rooms": {}}

func persist_room_data(area, room_data):
	area_db[area.name]["rooms"][room_data["name"]] = room_data

	# TODO write to file


func get_rooms_data(area):
	return area_db[area.name]["rooms"]

func get_room_data(area, room_name):
	return area_db[area.name]["rooms"][room_name]
