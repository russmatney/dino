@tool
class_name MvaniaArea
extends Node2D

@export var persist_area_data: bool :
	set(v):
		persist_area_data = false
		if v:
			if Engine.is_editor_hint() and self.name != &"":
				MvaniaGame.persist_area(self)

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
# set room data

func init_room_data():
	ensure_rooms()
	for room in rooms:
		# must be set before fetching room data
		room.area = self
		room.room_data = Util._or(MvaniaGame.get_room_data(room), {})

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

	var eles = Util.get_children_in_group(self, "elevators")
	for e in eles:
		return e.global_position

	Hood.warn("no spawn_node, parent_spawn_points, or elevators found, returning (0, 0)")
	return Vector2.ZERO

var spawn_node_path
func set_spawn_node(node_path: NodePath):
	spawn_node_path = node_path

###########################################################
# enter tree

func _enter_tree():
	# required for area db to pick this up
	add_to_group("mvania_areas", true)

###########################################################
# ready

func _ready():
	pause_rooms()

	if MvaniaGame.get_area_data(self) == null:
		# assuming we're not in a 'proper' MvaniaGame state
		MvaniaGame.persist_area(self)
		if Engine.is_editor_hint():
			Debug.prn("Persisted area data: \n")
			Debug.prn(MvaniaGame.get_area_data(self))

	init_room_data()

	call_deferred("maybe_spawn_player")

func maybe_spawn_player():
	if not Engine.is_editor_hint():
		await get_tree().create_timer(0.5).timeout
		if MvaniaGame.player == null:
			MvaniaGame.current_area = self
			MvaniaGame.spawn_player()

###########################################################
# draw

func _draw():
	if Engine.is_editor_hint():
		for room in rooms:
			draw_room_outline(room)
