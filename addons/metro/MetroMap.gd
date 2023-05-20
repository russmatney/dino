@tool
extends Control

################################################################
# vars

var zone_data = {}
var rooms = []

var only_visited = false

################################################################
# ready

func _ready():
	Hotel.entry_updated.connect(on_entry_updated)
	resized.connect(update)
	update()

func update():
	update_data()
	update_map()

################################################################
# hotel entry_updated

func on_entry_updated(entry):
	if Metro.zones_group in entry.get("groups", []):
		update()
	if Metro.rooms_group in entry.get("groups", []):
		update()
	if Metro.checkpoints_group in entry.get("groups", []):
		update()

################################################################
# helpers

func merged_rect(rms):
	var r = Rect2()
	for room_data in rms:
		var rect = room_data.get("rect")
		if rect:
			rect.position += room_data.get("position")
			r = r.merge(rect)
	return r

func calc_scale_factor(merged_rect):
	if size.y < size.x:
		return Vector2.ONE * (size.y / merged_rect.size.y)
	else:
		return Vector2.ONE * (size.x / merged_rect.size.x)

func scale_rect(rect, factor):
	return Rect2(rect) * Transform2D().scaled(factor)

func merged_and_offset(rms):
	var merged = merged_rect(rms)
	var scale_factor = calc_scale_factor(merged)
	merged = scale_rect(merged, scale_factor)

	var offset = Vector2.ZERO
	if merged.position.x < 0:
		offset.x = -merged.position.x
	if merged.position.y < 0:
		offset.y = -merged.position.y
	merged.position += offset

	return {merged=merged, offset=offset, scale_factor=scale_factor}


################################################################
# update data

func update_data():
	var current_zone = Metro.current_zone
	if not current_zone:
		if Engine.is_editor_hint():
			current_zone = Hotel.first({group=Metro.zones_group})
		else:
			Debug.warn("No current zone")
			return

	var zones = Hotel.query({zone_name=current_zone.name, group=Metro.zones_group})
	if len(zones) > 0:
		zone_data = zones[0]


################################################################
# update_map

signal new_merged_rect(rect)

var last_zone_name
func update_map():
	if len(zone_data) == 0:
		return
	var zone_name = zone_data.get("name")

	if last_zone_name == null or last_zone_name != zone_name:
		clear_map()
		last_zone_name = zone_name

	rooms = Hotel.query({zone_name=zone_name, group=Metro.rooms_group})
	if only_visited:
		rooms = rooms.filter(func(rm): return rm.get("visited"))
	var res = merged_and_offset(rooms)
	new_merged_rect.emit(res.merged)
	var offset = res.offset
	var scale_factor = res.scale_factor
	update_rooms(offset, scale_factor)


func clear_map():
	for c in get_children():
		if c is MetroMapRoom:
			c.free()

var map_room_scene = preload("res://addons/metro/MetroMapRoom.tscn")

signal room_has_player(room_data)

func update_rooms(offset: Vector2, scale_factor):
	for room_data in rooms:
		var room_rect = room_data.get("rect")

		if room_rect:
			var rect = Rect2(room_rect)
			rect.position += room_data["position"]
			rect = scale_rect(rect, scale_factor)
			rect.position += offset

			var room_name = str(room_data.get("name"))
			var map_room = get_node_or_null(room_name)
			if not map_room:
				map_room = map_room_scene.instantiate()
				map_room.name = room_name
				add_child(map_room)
				map_room.set_owner(self)

			if room_data.get("has_player"):
				room_has_player.emit(room_data, rect)

			map_room.set_room_data(room_data)
			map_room.size = rect.size
			map_room.position = rect.position
			map_room.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
			rooms.append(map_room)
