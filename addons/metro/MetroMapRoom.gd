@tool
extends Control
class_name MetroMapRoom

var room_data = {}
@onready var color_rect = $ColorRect

var checkpoints = []

## ready ###################################################################

func _ready():
	resized.connect(on_resized)


## on resize ###################################################################

func on_resized():
	var room_rect = room_data.get("rect")
	var scale_factor = size / room_rect.size
	for ch in checkpoints:
		ch.position -= room_rect.position
		ch.position *= scale_factor

	color_rect.size = size


## set room data ###################################################################

func set_room_data(data):
	room_data = data

	for ch in checkpoints:
		remove_child(ch)
	checkpoints = []
	Hotel.query({room_name=data.get("room_name"), group=Metro.checkpoints_group})\
		.map(add_checkpoint)

	var visited = room_data.get("visited")
	var has_player = room_data.get("has_player")

	if has_player:
		color_rect.set_color(Color(Color.AQUAMARINE, 0.9))
	elif visited:
		color_rect.set_color(Color(Color.PERU, 0.8))
	else:
		color_rect.set_color(Color(Color.GRAY, 0.6))


## add_checkpoint ###################################################################

func add_checkpoint(data):
	var checkpoint = ColorRect.new()
	checkpoint.position = data.get("position")
	checkpoint.size = Vector2.ONE * 10
	var color = Color(Color.RED, 0.7)
	if data.get("visit_count", 0) > 0:
		color = Color(Color.GREEN, 0.7)

	checkpoint.set_color(color)
	checkpoints.append(checkpoint)
	add_child(checkpoint)


## draw ################################################################

func _draw():
	if len(room_data) == 0:
		return

	var room_rect = room_data.get("rect")
	var scale_factor = size / room_rect.size

	room_rect.position -= room_rect.position
	room_rect = Rect2(room_rect) * Transform2D().scaled(scale_factor)

	draw_rect(room_rect, Color(Color.PERU, 0.7), false, 5.0)
