tool
extends Node2D

export(Array, PackedScene) var room_options = []
export(PackedScene) var final_room

var current_rooms = []
var total_room_width = 0
var active_room_count = 3

var final_room_idx = 8
var rooms_created = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if not room_options:
		print("[WARN]: no room options!")

	clear_current_rooms()

	# should we wait to add the player after the rooms are ready?
	create_rooms(active_room_count)

	if Engine.editor_hint:
		request_ready()

func clear_current_rooms():
	for r in current_rooms:
		r.queue_free()

	var to_del = []
	for r in current_rooms:
		to_del.append(r)
	for r in to_del:
		current_rooms.erase(r)
	total_room_width = 0
	rooms_created = 0
	print("Emptied current rooms: ", current_rooms)

func make_room():
	if rooms_created > final_room_idx:
		return

	var room_i = randi() % room_options.size()
	var room_opt = room_options[room_i]

	if rooms_created == final_room_idx && final_room:
		room_opt = final_room

	var new_room = room_opt.instance()
	var next_w = new_room.room_width()
	var offset_x = total_room_width + next_w / 2
	new_room.position.x = offset_x

	# update width so we can keep appending rooms
	total_room_width += next_w

	Util.ensure_connection(new_room, "player_entered", self, "room_entered", [new_room])
	Util.ensure_connection(new_room, "player_exited", self, "room_exited", [new_room])

	# update rooms array
	current_rooms.append(new_room)

	rooms_created += 1

	return new_room

func create_rooms(count: int):
	for i in count:
		var new_room = make_room()
		if new_room:
			call_deferred("add_child", new_room)
		else:
			print("No more rooms, says code")

func room_entered(_player, room):
	var current_room_index = current_rooms.find(room)
	var current_room_count = current_rooms.size()
	var remaining_rooms = current_room_count - 1 - current_room_index
	var rooms_to_make = active_room_count - remaining_rooms

	if rooms_to_make:
		create_rooms(rooms_to_make)

func room_exited(_player, room):
	var exited_room_index = current_rooms.find(room)

	var to_delete = []
	# remove rooms before the just-exited one
	for idx in exited_room_index - 2: # subtract 2 for some buffer
		to_delete.append(current_rooms[idx])

	# delete in separate loop b/c array indexes shift in place
	for r in to_delete:
		current_rooms.erase(r)
		r.queue_free()
		# call_deferred("remove_child", r)
