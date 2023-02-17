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

func ensure_rooms():
	if len(rooms) == 0:
		for c in get_children():
			if c is MvaniaRoom:
				rooms.append(c)

func pause_rooms():
	ensure_rooms()
	for r in rooms:
		r.pause()
	print("paused ", len(rooms), " rooms.")

func draw_room_outline(room: MvaniaRoom):
	var rect = room.used_rect()
	rect.position += room.position
	draw_rect(rect, Color.MAGENTA, false, 2.0)


###########################################################
# ready

func persist_area():
	MvaniaGame.persist_area(self)

	if Engine.is_editor_hint():
		prn("Persisted area data: \n")
		prn(MvaniaGame.get_area_data(self))

###########################################################
# ready

func _ready():
	pause_rooms()

	if Engine.is_editor_hint():
		persist_area()


###########################################################
# draw

func _draw():
	if Engine.is_editor_hint():
		for room in rooms:
			draw_room_outline(room)
