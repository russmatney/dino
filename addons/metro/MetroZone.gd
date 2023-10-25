@tool
class_name MetroZone
extends Node2D

## enter tree ##########################################################

func _enter_tree():
	add_to_group(Metro.zones_group, true)

## ready ##########################################################

func _ready():
	pause_rooms()
	Hotel.register(self)

	# unmanaged game (dev mode) helpers
	if not Engine.is_editor_hint() and not Game.is_managed:
		Metro.ensure_current_zone(self)
		Game.maybe_spawn_player.call_deferred({
			# passing a fn b/c we don't want side-effects,
			# and this avoids calling it when already respawning
			spawn_coords_fn=player_spawn_coords,
			})

## Hotel data ##########################################################

func is_hotel_root():
	return true

func hotel_data():
	return {scene_file_path=scene_file_path}

func check_out(_data):
	pass


## draw ##########################################################

func _draw():
	if Engine.is_editor_hint():
		for room in rooms:
			draw_room_outline(room)

## rooms ##########################################################

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

## spawn coords ##########################################################

var spawn_node_path
func set_spawn_node(node_path: NodePath):
	spawn_node_path = node_path

var travel_points_group = "travel_points"

## NOTE this function has side-effects!
## It clears the spawn_node_path when used!
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

	if Game.is_managed:
		markers = markers.filter(func(ma): return not ma.dev_only)
	else:
		markers.sort_custom(func(ma, mb): return ma.dev_only)

	markers.sort_custom(func(ma, mb): return ma.last_visited > mb.last_visited)

	if len(markers) > 0:
		return markers[0].global_position

	var eles = Util.get_children_in_group(self, travel_points_group)
	for e in eles:
		return e.global_position

	Debug.warn("no spawn_node, parent_spawn_points, or travel points found, returning (0, 0)")
	return Vector2.ZERO

