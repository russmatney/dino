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

	if not Engine.is_editor_hint():
		recreate_db()

###########################################################
# area DB

var area_scenes = [
	preload("res://src/mvania19/maps/area01/Area01.tscn")
	]

var area_db = {}

func recreate_db():
	area_db = {}
	for area in area_scenes:
		var area_inst = area.instantiate()
		area_inst.persist_area()

	prn("area_db recreated: \n", area_db)

func persist_area(area):
	# TODO don't overwrite if exists?
	area_db[area.name] = {"rooms": {}}

func persist_room_data(area, room_data):
	area_db[area.name]["rooms"][room_data["name"]] = room_data


func get_rooms_data(area):
	return area_db[area.name]["rooms"]

func get_room_data(area, room_name):
	return area_db[area.name]["rooms"][room_name]
