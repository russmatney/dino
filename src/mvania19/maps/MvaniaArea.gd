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

func draw_room_outline(room: MvaniaRoom):
	var rect = room.used_rect()
	rect.position += room.position
	draw_rect(rect, Color.MAGENTA, false, 2.0)


###########################################################
# persist

func persist_area():
	MvaniaGame.persist_area(self)

	if Engine.is_editor_hint():
		prn("Persisted area data: \n")
		prn(MvaniaGame.get_area_data(self))

###########################################################
# set room data

func init_room_data():
	ensure_rooms()
	for room in rooms:
		# must be set before fetching room data
		room.area = self
		room.room_data = MvaniaGame.get_room_data(room)

###########################################################
# spawn coords

func player_spawn_coords() -> Vector2:
	ensure_rooms()

	if spawn_node_path:
		var spawn_node = self.get_node(spawn_node_path)
		return spawn_node.global_position

	var markers = Util.get_children_in_group(self, "player_spawn_points")

	for mark in markers:
		# if mark something or other, use last checkpoint
		return mark.global_position

	prn("[WARN] no parent_spawn_points or spawn_node found, returning (0, 0)")
	return Vector2.ZERO

var spawn_node_path
func set_spawn_node(node_path: NodePath):
	spawn_node_path = node_path

## removes any player nodes attached to areas and rooms
## these are added during development and _should_ be cleaned up
## but here's a just-in-case fix
func drop_player():
	for c in get_children():
		if c is MvaniaRoom:
			for d in c.get_children():
				if d.is_in_group("player"):
					d.free()

		if c.is_in_group("player"):
			c.free()


###########################################################
# ready

func _ready():
	pause_rooms()

	if MvaniaGame.get_area_data(self) == null:
		persist_area()

	init_room_data()

###########################################################
# draw

func _draw():
	if Engine.is_editor_hint():
		for room in rooms:
			draw_room_outline(room)
