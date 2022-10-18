tool
extends Node2D

export(Array, PackedScene) var room_options = []

var current_rooms = []
var current_width = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if not room_options:
		print("[WARN]: no room options!")
	current_rooms = []

	# should we wait to add the player after the rooms are ready?
	create_rooms()

	if Engine.editor_hint:
		request_ready()

func create_rooms():
	if current_rooms.size() == 30:
		return

	var room_i = randi() % room_options.size()

	var next_room = room_options[room_i].instance()
	var next_w = next_room.room_width()
	var offset_x = current_width + next_w / 2

	next_room.position.x = offset_x

	call_deferred("add_child", next_room)
	current_rooms.append(next_room)
	current_width += next_w


	create_rooms()
