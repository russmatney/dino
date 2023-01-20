tool
extends Node2D

func prn(msg, msg2=null, msg3=null, msg4=null, msg5=null):
	var s = "[TowerClimb] "
	if msg5:
		print(str(s, msg, msg2, msg3, msg4, msg5))
	elif msg4:
		print(str(s, msg, msg2, msg3, msg4))
	elif msg3:
		print(str(s, msg, msg2, msg3))
	elif msg2:
		print(str(s, msg, msg2))
	elif msg:
		print(str(s, msg))

func collect_tiles():
	var ts = []
	ts.append_array(get_tree().get_nodes_in_group("coldfire_bluetile"))
	ts.append_array(get_tree().get_nodes_in_group("coldfire_redtile"))
	ts.append_array(get_tree().get_nodes_in_group("coldfire_darktile"))
	ts.append_array(get_tree().get_nodes_in_group("coldfire_yellowtile"))
	return ts

######################################################################
# ready

var tiles

var ready = false
func _ready():
	ready = true
	randomize()
	disable_collisions()

func disable_collisions(_opts={}):
	# disable all collisions except darktile
	tiles = collect_tiles()
	for t in tiles:
		if not t.is_in_group("coldfire_darktile"):
			# disable collisions with player
			t.set_collision_layer_bit(0, 0)
			t.set_collision_mask_bit(1, 0)
			t.set_collision_mask_bit(2, 0)

######################################################################
# triggers

export(bool) var clear setget do_clear
func do_clear(_v):
	if ready:
		for c in get_children():
			c.queue_free()

export(String, "middle", "end") var next_room_type = "middle" setget set_next_room_type
func set_next_room_type(val):
	next_room_type = val

######################################################################
# build tower

func rooms():
	var rs = []
	for c in get_children():
		if c is TowerRoom:
			print("found tower room!")
			rs.append(c)
	return rs

func get_start_room():
	for r in rooms():
		if r.is_in_group("tower_start_room"):
			return r

func get_previous_room():
	var rs = rooms()
	print("previous rooms: ", rs)
	return rs.back()

######################################################################
# add neighboring room

var start_room_scene = preload("res://src/tower/rooms/TowerStartRoom.tscn")
var middle_room_scene = preload("res://src/tower/rooms/TowerMiddleRoom.tscn")
var end_room_scene = preload("res://src/tower/rooms/TowerEndRoom.tscn")

export(int) var cell_size = 16
export(int) var img_size = 50

func add_room_inst(room_scene):
	var room = room_scene.instance()
	add_child(room)
	room.set_owner(self)
	room.cell_size = cell_size
	room.img_size = img_size
	room.setup()
	room.regen_tilemaps()
	return room

export(bool) var add_room setget do_add_room
func do_add_room(_v):
	if ready:
		var start_room = get_start_room()
		if not start_room:
			add_room_inst(start_room_scene)
		elif next_room_type == "middle":
			add_room_inst(middle_room_scene)
		elif next_room_type == "end":
			add_room_inst(end_room_scene)
