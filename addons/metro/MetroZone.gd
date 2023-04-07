@tool
class_name MetroZone
extends Node2D

###########################################################
# enter tree

func _enter_tree():
	# required for hotel to pick this up
	add_to_group("metro_zones", true)

###########################################################
# ready

func _ready():
	pause_rooms()

	Hotel.book(self.scene_file_path)
	Hotel.register(self)

	if not Engine.is_editor_hint():
		if Metro.current_zone != self:
			Debug.warn("metro zone had to self-set current zone")
			Metro.current_zone = self

	Game.maybe_spawn_player.call_deferred()

###########################################################
# Hotel data

func hotel_data():
	return {scene_file_path=scene_file_path}

func check_out(_data):
	pass


###########################################################
# draw

func _draw():
	if Engine.is_editor_hint():
		for room in rooms:
			draw_room_outline(room)

###########################################################
# rooms

var rooms: Array[MetroRoom] = []

func ensure_rooms():
	if len(rooms) == 0:
		for c in get_children():
			if c is MetroRoom:
				rooms.append(c)

func pause_rooms():
	ensure_rooms()
	for r in rooms:
		r.pause()

func draw_room_outline(room: MetroRoom):
	var rect = room.used_rect()
	rect.position += room.position
	draw_rect(rect, Color.MAGENTA, false, 2.0)



###########################################################
# spawn coords

var spawn_node_path
func set_spawn_node(node_path: NodePath):
	spawn_node_path = node_path

func player_spawn_coords() -> Vector2:
	ensure_rooms()

	if spawn_node_path:
		var spawn_node = get_node(spawn_node_path)
		if spawn_node:
			# clear this override once it is used
			spawn_node_path = null
			return spawn_node.global_position
		else:
			Debug.warn("Invalid spawn_node_path", self, spawn_node_path)

	var markers = Util.get_children_in_group(self, "player_spawn_points")
	markers = markers.filter(func(ma): return ma.active)

	if Game.managed_game:
		markers = markers.filter(func(ma): return not ma.dev_only)

	markers.sort_custom(func(ma, mb): return ma.last_sat_at > mb.last_sat_at)

	if len(markers) > 0:
		return markers[0].global_position

	var eles = Util.get_children_in_group(self, "elevators")
	for e in eles:
		return e.global_position

	Debug.warn("no spawn_node, parent_spawn_points, or elevators found, returning (0, 0)")
	return Vector2.ZERO

