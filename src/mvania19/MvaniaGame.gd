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
	Hood.hud_ready.connect(_on_hud_ready)
	Hood.found_player.connect(_on_player_found)
	if not Engine.is_editor_hint():
		recreate_db()

###########################################################
# area DB

var area_scenes = [
	preload("res://src/mvania19/maps/area01/Area01.tscn")
	]

var area_db = {}

func recreate_db():
	prn("recreating area_db")
	area_db = {}
	for area in area_scenes:
		var area_inst = area.instantiate()
		area_inst.persist_area()
	prn("recreated area_db: ", len(area_db))

func print_area_db():
	# TODO pretty print
	prn(area_db)

func persist_area(area):
	area.ensure_rooms()
	if len(area.rooms) == 0:
		push_error(area.name, " [ERR] No rooms!")
		return

	# don't overwrite if exists?
	area_db[area.name] = {"rooms": {}}

	for r in area.rooms:
		persist_room_data(area, r.to_room_data())

func persist_room_data(area, room_data):
	area_db[area.name]["rooms"][room_data["name"]] = room_data

func get_area_data(area):
	return area_db[area.name]

func get_rooms_data(area):
	return area_db[area.name]["rooms"]

func get_room_data(area, room_name):
	return area_db[area.name]["rooms"][room_name]


###########################################################
# Player

var player
func _on_player_found(p):
	prn("player found")
	player = p

###########################################################
# HUD

func _on_hud_ready():
	prn("hud ready")
	# TODO set current room, area data?
