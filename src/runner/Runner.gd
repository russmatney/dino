tool
extends Node2D

export(Array, PackedScene) var initial_room_options = []
var room_options = []
export(PackedScene) var final_room
export(Array, PackedScene) var gap_room_options

var room_queue = []
var current_rooms = []
var accumulated_room_width = 0
var active_room_count = 5

onready var rooms_node = $Rooms

# Called when the node enters the scene tree for the first time.
func _ready():
	if not initial_room_options:
		print("[WARN]: no room options!")

	room_options = initial_room_options.duplicate()
	clear_current_rooms()

	# should we wait to add the player after the rooms are ready?
	add_rooms_to_scene(active_room_count)

	if Engine.editor_hint:
		request_ready()

func clear_current_rooms():
	for r in current_rooms:
		r.queue_free()

	var to_del = []
	for r in current_rooms:
		to_del.append(r)
	for r in to_del:
		current_rooms.erase(r) # is this even necssary after they are queue_freed? probably?
	accumulated_room_width = 0

var no_more_rooms = false

# TODO unit test for this function
func choose_next_room_instance():
	# no rooms yet? start in a gap room
	if not current_rooms:
		var room_i = randi() % gap_room_options.size()
		return gap_room_options[room_i].instance()

	# some rooms we haven't seen yet? let's see them!
	if room_options:
		# none queued, pulling new random room
		var room_i = randi() % room_options.size()
		# pop from opts - we won't see it anymore
		return room_options.pop_at(room_i).instance()

	# some unfinished rooms? gimme one
	if room_queue:
		var room_i = randi() % room_queue.size()
		return room_queue.pop_at(room_i)

	# we might need a gap room if a current room is not finished
	# i.e. we might be in/near an unfinished room right now
	var current_unfinished
	for r in current_rooms:
		if not r.is_finished():
			current_unfinished = r
			break

	# add a gap room until the current is requeued
	if current_unfinished:
		var room_i = randi() % gap_room_options.size()
		return gap_room_options[room_i].instance()

	# nothing left to finish, mark done and return the final
	no_more_rooms = true
	return final_room.instance()

# prepare room to be added to the scene
func prep_room():
	if no_more_rooms:
		return

	var next_room = choose_next_room_instance()
	if not next_room:
		print("[WARN] no next_room!")

	if not next_room.has_method("x_offset"):
		print("[WARN] next_room has no x_offset?: ", next_room)

	var next_offset = next_room.x_offset()
	# don't try `.is_null()` here! floats can't handle it
	if next_offset == null:
		print("[WARN] nil next_offset calculated for room: ", next_room)
		next_offset = 0

	# could abstract this prep out, it's runner specific
	# offset is the distance from the room's origin to the left side of the enterBox/roomBox
	var offset_x = accumulated_room_width - next_room.x_offset()
	next_room.position.x = offset_x

	# update width so we can keep appending rooms
	var next_w = next_room.room_width()
	accumulated_room_width += next_w

	Util.ensure_connection(next_room, "player_entered", self, "room_entered", [next_room])
	Util.ensure_connection(next_room, "player_exited", self, "room_exited", [next_room])

	# update rooms array
	current_rooms.append(next_room)

	return next_room

func add_rooms_to_scene(count: int):
	for i in count:
		var room = prep_room()
		if room:
			# only need to add newly instanced rooms
			# the others get moved when .position.x is set
			if not room.get_parent():
				rooms_node.call_deferred("add_child", room, true)

# TODO add unit tests
func room_entered(_player, room):
	print("\n\n--------------------------------------------------------------------")
	print("entered: ", room)
	var current_room_index = current_rooms.find(room)
	var current_room_count = current_rooms.size()
	var remaining_rooms = current_room_count - 1 - current_room_index
	var rooms_to_make = active_room_count - remaining_rooms

	if rooms_to_make:
		add_rooms_to_scene(rooms_to_make)

# TODO add unit tests
func room_exited(_player, room):
	var exited_room_index = current_rooms.find(room)

	# check just-exited room for completion
	if not room.is_finished():
		if not room_queue.has(room):
			room_queue.append(room)

	# remove rooms before the just-exited one
	var to_delete = []
	var to_remove = []

	for idx in exited_room_index - 2: # subtract 2 for some buffer
		var r = current_rooms[idx]
		# TODO this feels like an extra is_finished call... :/
		if r.is_finished():
			to_delete.append(r)
		else:
			to_remove.append(r)

	# delete in separate loop b/c array indexes shift in place
	for r in to_delete:
		current_rooms.erase(r)
		r.queue_free()

	for r in to_remove:
		# this room should have been queued by now
		current_rooms.erase(r)
