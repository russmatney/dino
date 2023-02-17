@tool
class_name MvaniaArea
extends Node2D

func prn(msg, msg2=null, msg3=null):
	if msg3:
		print("[MvaniaArea ", name, "]: ", msg, msg2, msg3)
	elif msg2:
		print("[MvaniaArea ", name, "]: ", msg, msg2)
	else:
		print("[MvaniaArea ", name, "]: ", msg)

###########################################################
# rooms

var rooms: Array[MvaniaRoom] = []

func collect_rooms():
	rooms = []
	for c in get_children():
		if c is MvaniaRoom:
			rooms.append(c)
	prn("found rooms: ", len(rooms))

func draw_room_outline(room: MvaniaRoom):
	var rect = room.used_rect()
	rect.position += room.position
	draw_rect(rect, Color.MAGENTA, false, 2.0)

###########################################################
# ready

func _ready():
	prn("ready")
	collect_rooms()

	MvaniaGame.persist_area(self)

	for r in rooms:
		var room_data = {
			"name": r.name,
			"scene_file_path": r.scene_file_path,
			"position": r.position,
			"rect": r.used_rect(),
			}

		MvaniaGame.persist_room_data(self, room_data)

	print(MvaniaGame.get_rooms_data(self))


###########################################################
# draw

func _draw():
	for room in rooms:
		draw_room_outline(room)
