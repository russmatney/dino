@tool
extends Node2D

# TODO center camera on current room
# TODO update to fill in rooms as they are visited

################################################################
# ready

func _ready():
	MvaniaGame.area_db_updated.connect(update)
	if len(MvaniaGame.area_db) > 0:
		update(MvaniaGame.area_db)

func update(area_db):
	print("minimap update!", area_db)
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
		var rect = room_data["rect"]
		rect.position += room_data["position"]
		r = r.merge(rect)
	return r

################################################################
# update data

var area_data = {}

func update_minimap_data():
	# TODO proper minimap lifecycle
	area_data = Util._or(MvaniaGame.get_current_area_data(), MvaniaGame.area_db.values()[0])
	print("updated data? ", area_data)
	if area_data == null:
		area_data = {}

	if len(area_data) == 0:
		if Engine.is_editor_hint():
			# draw a map to be sure things work
			var area = MvaniaGame.area_scenes[0].instantiate()
			area_data = MvaniaGame.to_area_data(area)
			if area_data == null:
				area_data = {}
		else:
			return

################################################################
# update_map

var rooms = []
@onready var cam = $Camera2D

var last_area_name
func update_map():
	if len(area_data) == 0:
		return

	if last_area_name == null or last_area_name != area_data["name"]:
		clear_map()
		last_area_name = area_data["name"]
	update_rooms()

func clear_map():
	for c in get_children():
		if c is ColorRect:
			c.free()

func update_rooms():
	var merged = merged_rect(area_data["rooms"].values())
	var offset = Vector2.ZERO
	if merged.position.x < 0:
		offset.x = -merged.position.x
	if merged.position.y < 0:
		offset.y = -merged.position.y

	for room_data in area_data["rooms"].values():
		var rect = room_data["rect"]
		rect.position += room_data["position"] - offset
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
			c_rect.set_color(Color.CRIMSON)
			cam.set_offset(to_global(rect.get_center()))
		elif visited:
			c_rect.set_color(Color.PERU)
		else:
			c_rect.set_color(Color.AQUAMARINE)

################################################################
# input

# func _unhandled_input(event):
# 	if event is InputEventMouseButton:
# 		print("pos clicked: ", event.global_position)
# 		print("pos clicked: ", event.position)
# 		cam.set_offset(event.position)

################################################################
# draw

# func _draw():
# 	draw_rect(Rect2(Vector2(32, 32), Vector2(32, 32)), Color.MAGENTA, true)

# 	if not area_data == null and len(area_data) > 0:
# 		var merged = merged_rect(area_data["rooms"].values())
# 		var offset = Vector2.ZERO
# 		if merged.position.x < 0:
# 			offset.x = -merged.position.x
# 		if merged.position.y < 0:
# 			offset.y = -merged.position.y

# 		draw_rect(merged, Color.MAGENTA, false)

# 		print("merged: ", merged)
# 		print("offset: ", offset)
# 		for room_data in area_data["rooms"].values():
# 			var rect = room_data["rect"]
# 			rect.position += room_data["position"] + offset
# 			var visited = room_data["visited"]

# 			print("room rect: ", room_data["name"], " ", rect)

# 			draw_rect(rect, Color.MAGENTA, visited, 2.0)
