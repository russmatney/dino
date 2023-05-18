@tool
extends Control

# TODO center camera on current room
# TODO update to fill in rooms as they are visited

################################################################
# ready

func _ready():
	Hotel.entry_updated.connect(update)

	update_minimap_data()
	update_map()


func update(entry):
	if Metro.zones_group in entry.get("groups", []):
		update_minimap_data()
		update_map()
	if Metro.rooms_group in entry.get("groups", []):
		update_minimap_data()
		update_map()

################################################################
# process

func _process(_delta):
	pass

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
	return rect * Transform2D().scaled(factor)


func merged_and_offset(rms):
	var merged = merged_rect(rms)
	Debug.pr("merged", merged)

	var scale_factor = calc_scale_factor(merged)
	merged = scale_rect(merged, scale_factor)

	Debug.pr("scaled merged", merged)

	var offset = Vector2.ZERO
	if merged.position.x < 0:
		offset.x = -merged.position.x
	if merged.position.y < 0:
		offset.y = -merged.position.y

	Debug.pr("offset", offset)

	merged.position += offset

	Debug.pr("scaled and adjusted merged", merged)

	return {merged=merged, offset=offset, scale_factor=scale_factor}


################################################################
# update data

var zone_data = {}

func update_minimap_data():
	var current_zone = Metro.current_zone
	if not current_zone:
		if Engine.is_editor_hint():
			current_zone = Hotel.first({group=Metro.zones_group})
		else:
			Debug.pr("No current zone")
			return

	var zones = Hotel.query({zone_name=current_zone.name, group=Metro.zones_group})
	if len(zones) > 0:
		zone_data = zones[0]

################################################################
# update_map

var rooms = []

var last_zone_name
func update_map():
	if len(zone_data) == 0:
		return
	var zone_name = zone_data.get("name")

	if last_zone_name == null or last_zone_name != zone_name:
		clear_map()
		last_zone_name = zone_name

	rooms = Hotel.query({zone_name=zone_name, group=Metro.rooms_group})
	var res = merged_and_offset(rooms)
	var merged = res.merged
	var offset = res.offset
	var scale_factor = res.scale_factor
	update_rooms(offset, scale_factor)


func clear_map():
	for c in get_children():
		if c is ColorRect:
			c.free()

func update_rooms(offset: Vector2, scale_factor):
	for room_data in rooms:
		var rect = room_data.get("rect")
		if rect:
			rect.position += room_data["position"]
			rect = scale_rect(rect, scale_factor)
			rect.position += offset

			var visited = room_data.get("visited")
			var has_player = room_data.get("has_player")
			var room_name = str(room_data.get("name"))

			var c_rect = get_node_or_null(room_name)
			if not c_rect:
				c_rect = ColorRect.new()
				c_rect.name = room_name
				add_child(c_rect)
				c_rect.set_owner(self)

			c_rect.size = rect.size
			c_rect.position = rect.position
			c_rect.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
			rooms.append(c_rect)

			if has_player:
				c_rect.set_color(Color(Color.PERU,0.8))
			elif visited:
				c_rect.set_color(Color(Color.GRAY, 0.7))
			else:
				c_rect.set_color(Color(Color.AQUAMARINE, 0.2))

################################################################
# draw

func _draw():
	if not zone_data == null and len(zone_data) > 0:
		var rms = Hotel.query({zone_name=zone_data["name"], group=Metro.rooms_group})
		var res = merged_and_offset(rooms)
		var merged = res.merged
		var offset = res.offset
		var scale_factor = res.scale_factor

		draw_rect(merged, Color.MAGENTA, false)

		for room in rms:
			var room_rect = room.rect
			room_rect.position += room.position
			room_rect = scale_rect(room_rect, scale_factor)
			room_rect.position += offset
			draw_rect(room_rect, Color.PERU, false)
