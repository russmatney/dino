@tool
extends Control
class_name MetroMapRoom

var room_data = {}
@onready var color_rect = $ColorRect

var checkpoints = []
var powerups = []

## ready ###################################################################

func _ready():
	resized.connect(on_resized)


## on resize ###################################################################

func on_resized():
	checkpoints.map(set_entity_position)
	powerups.map(set_entity_position)
	color_rect.size = size

func set_entity_position(ch):
	var room_rect = room_data.get("rect")
	if room_rect == null:
		return
	var scale_factor = size / room_rect.size
	ch.position -= room_rect.position
	ch.position *= scale_factor


## set room data ###################################################################

var entities = {
	checkpoints={
		group=Metro.checkpoints_group,
		get_color=func(ent):
		if ent.get("visit_count", 0) > 0:
			return Color(Color.GREEN, 0.7)},
	powerups={
		group="powerups",
		get_color=func(ent):
		return Color(Color.GRAY, 0.9) if ent.get("picked_up") else Color(Color.GREEN, 0.7) }}

func reset_entities(room_name):
	for e in entities:
		for ch in self.get(e):
			remove_child(ch)
			ch.queue_free()
		self[e] = []
		Hotel.query({room_name=room_name, group=entities[e].group})\
			.filter(func(ent): return ent.get("position"))\
			.map(func(ent): add_entity(e, ent, entities[e].get_color))


func set_room_data(data):
	room_data = data

	reset_entities(data.get("room_name"))

	var visited = room_data.get("visited")
	var has_player = room_data.get("has_player")

	if color_rect:
		if has_player:
			color_rect.set_color(Color(Color.AQUAMARINE, 0.9))
		elif visited:
			color_rect.set_color(Color(Color.PERU, 0.8))
		else:
			color_rect.set_color(Color(Color.GRAY, 0.6))


## add_entity ###################################################################

func add_entity(e_key, data, get_color=null):
	if data.get("position") == null:
		Log.warn("Cannot add entity without hotel db `position` attr")
		return
	var ent = ColorRect.new()
	ent.position = data.get("position")
	ent.size = Vector2.ONE * 10

	set_entity_position(ent)

	var color = Color(Color.RED, 0.7)
	if get_color != null:
		var new_color = get_color.call(data)
		if new_color != null:
			color = new_color

	ent.set_color(color)
	self[e_key].append(ent)
	add_child(ent)

## draw ################################################################

func _draw():
	if len(room_data) == 0:
		return

	var room_rect = room_data.get("rect")
	var scale_factor = size / room_rect.size

	room_rect.position -= room_rect.position
	room_rect = Rect2(room_rect) * Transform2D().scaled(scale_factor)

	draw_rect(room_rect, Color(Color.PERU, 0.7), false, 5.0)
