@tool
extends Node2D


func _ready():
	update_minimap_data()

func _process(_delta):
	pass

var area_data = {}

func update_minimap_data():
	area_data = MvaniaGame.get_current_area_data()

	if area_data == null or len(area_data) == 0:
		# dev only helper!
		if Engine.is_editor_hint():
			var area = MvaniaGame.area_scenes[0].instantiate()
			area_data = MvaniaGame.to_area_data(area)
			print("created area_data: ", area_data)
			print("room data: ", area_data["rooms"])
		else:
			return
	else:
		print("existing area data")
		print("room data: ", area_data["rooms"])

func merged_rect(rooms):
	var r = Rect2()
	for room_data in rooms:
		var rect = room_data["rect"]
		rect.position += room_data["position"]
		r = r.merge(rect)
	return r

# TODO center camera on current room
# TODO update to fill in rooms as they are visited

func _draw():
	draw_rect(Rect2(Vector2(32, 32), Vector2(32, 32)), Color.MAGENTA, true)

	if not area_data == null and len(area_data) > 0:
		var merged = merged_rect(area_data["rooms"].values())
		var offset = Vector2.ZERO
		if merged.position.x < 0:
			offset.x = -merged.position.x
		if merged.position.y < 0:
			offset.y = -merged.position.y

		print("merged: ", merged)
		print("offset: ", offset)
		for room_data in area_data["rooms"].values():
			var rect = room_data["rect"]
			rect.position += room_data["position"] + offset
			var visited = room_data["visited"]

			print("room rect: ", room_data["name"], " ", rect)

			draw_rect(rect, Color.MAGENTA, visited, 2.0)
