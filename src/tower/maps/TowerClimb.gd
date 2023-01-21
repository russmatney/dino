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
	ts.append_array(get_tree().get_nodes_in_group("bluetile"))
	ts.append_array(get_tree().get_nodes_in_group("redtile"))
	ts.append_array(get_tree().get_nodes_in_group("darktile"))
	ts.append_array(get_tree().get_nodes_in_group("yellowtile"))
	return ts

######################################################################
# ready

var tiles

onready var player = $Player

var ready = false
func _ready():
	ready = true
	randomize()
	calc_rect()

	player.connect("fired_bullet", self, "add_bullet")

# TODO don't wrap into walls
# func _physics_process(_delta):
# 	# TODO disable camera smoothing if we're going to jump across?
# 	wrap_thing(player)

#   # TODO fix wrap disabling bullet collisions
# 	for ar in bullets:
# 		wrap_thing(ar)


var bullets = []
func add_bullet(b):
	bullets.append(b)
	b.connect("bullet_dying", self, "remove_bullet")

func remove_bullet(b):
	bullets.erase(b)

func wrap_thing(thing):
	if thing and is_instance_valid(thing):
		thing.position.x = wrapf(thing.position.x, rect.position.x, rect.end.x)
		thing.position.y = wrapf(thing.position.y, rect.position.y, rect.end.y)

######################################################################
# triggers

export(bool) var recalc_rect setget do_calc_rect
func do_calc_rect(_v):
	if ready:
		calc_rect()

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

		rect = calc_rect()

######################################################################
# calc rect

var rect
func calc_rect():
	var new_rect = Rect2()
	for r in rooms():
		var rr = r.calc_rect_global()
		new_rect = new_rect.merge(rr)

	rect = new_rect
	return rect
