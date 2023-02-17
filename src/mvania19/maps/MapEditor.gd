@tool
extends Node2D

func prn(msg, msg2=null, msg3=null):
	if msg3:
		print("[Mvania MapEditor]: ", msg, msg2, msg3)
	elif msg2:
		print("[Mvania MapEditor]: ", msg, msg2)
	else:
		print("[Mvania MapEditor]: ", msg)

var rooms: Array[MvaniaRoom] = []

func collect_rooms():
	rooms = []
	for c in get_children():
		if c is MvaniaRoom:
			rooms.append(c)
	prn("found rooms: ", len(rooms))


func _ready():
	print("map editor running")
	collect_rooms()

	for r in rooms:
		print("\n")
		prn(r.scene_file_path)
		prn(r.name)
		prn(r.position)
		prn(r.global_position)
		var tmap_rect = r.tilemap_rect()
		prn("tmap rect: ", tmap_rect)
		var used_rect = r.used_rect()
		prn("used rect: ", used_rect)
		prn("used rect end: ", used_rect.end)
