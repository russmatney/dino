@tool
extends Node2D

# TODO center camera on current room
# TODO update to fill in rooms as they are visited

################################################################
# ready

func _ready():
	Hotel.entry_updated.connect(update)

	update_minimap_data()
	update_map()


func update(entry):
	if "metro_zones" in entry.get("groups", []):
		update_minimap_data()
		update_map()
	if "metro_rooms" in entry.get("groups", []):
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

################################################################
# update data

var zone_data = {}

func update_minimap_data():
	var current_zone = Metro.current_zone
	if not current_zone:
		if Engine.is_editor_hint():
			current_zone = Hotel.first({group="metro_zones"})
		else:
			Debug.pr("No current zone")
			return

	var zones = Hotel.query({zone_name=current_zone.name, group="metro_zones"})
	if len(zones) > 0:
		zone_data = zones[0]

################################################################
# update_map

var rooms = []
@onready var cam = $Camera2D

var last_zone_name
func update_map():
	if len(zone_data) == 0:
		return

	if last_zone_name == null or last_zone_name != zone_data["name"]:
		clear_map()
		last_zone_name = zone_data["name"]

	rooms = Hotel.query({zone_name=zone_data["name"], group="metro_rooms"})
	var merged = merged_rect(rooms)
	var offset = Vector2.ZERO
	if merged.position.x < 0:
		offset.x = -merged.position.x
	if merged.position.y < 0:
		offset.y = -merged.position.y

	merged.position += offset

	update_rooms(offset)
	update_camera_limits(merged)

func clear_map():
	for c in get_children():
		if c is ColorRect:
			c.free()

func update_rooms(offset: Vector2):
	for room_data in rooms:
		var rect = room_data.get("rect")
		if rect:
			rect.position += room_data["position"] + offset
			var visited = room_data["visited"]
			var has_player = "has_player" in room_data and room_data["has_player"]

			var c_rect = get_node_or_null(str(room_data["name"]))
			if not c_rect:
				c_rect = ColorRect.new()
				c_rect.name = room_data["name"]
				add_child(c_rect)
				c_rect.set_owner(self)
			c_rect.size = rect.size
			c_rect.position = rect.position
			c_rect.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
			rooms.append(c_rect)

			if has_player:
				c_rect.set_color(Color(Color.PERU,0.8))
				cam.set_position(rect.get_center())
			elif visited:
				c_rect.set_color(Color(Color.GRAY, 0.7))
			else:
				c_rect.set_color(Color(Color.AQUAMARINE, 0.2))

var limit_offset = 15
var viewport_dim = 256
func update_camera_limits(merged: Rect2):
	cam.set_limit(SIDE_LEFT, merged.position.x - limit_offset)
	cam.set_limit(SIDE_RIGHT, max(viewport_dim, merged.size.x / 2.0 + merged.position.x - limit_offset * 2))
	cam.set_limit(SIDE_TOP, merged.position.y - limit_offset)
	cam.set_limit(SIDE_BOTTOM, max(viewport_dim, merged.size.y / 2.0 + merged.position.y - limit_offset * 2))

################################################################
# draw

# func _draw():
# 	if not zone_data == null and len(zone_data) > 0:
# 		var merged = merged_rect(zone_data["rooms"].values())
# 		var offset = Vector2.ZERO
# 		if merged.position.x < 0:
# 			offset.x = -merged.position.x
# 		if merged.position.y < 0:
# 			offset.y = -merged.position.y

# 		Debug.prn("(draw)merged rect (pre-offset): ", merged)
# 		merged.position += offset
# 		Debug.prn("(draw)merged rect: ", merged)
# 		draw_rect(merged, Color.MAGENTA, false)
