tool
extends Node2D

var dark_tile_scene = preload("res://addons/reptile/tilemaps/coldfire/ColdFireDark.tscn")
var blue_tile_scene = preload("res://addons/reptile/tilemaps/coldfire/ColdFireBlue.tscn")
var red_tile_scene = preload("res://addons/reptile/tilemaps/coldfire/ColdFireRed.tscn")
var yellow_tile_scene = preload("res://addons/reptile/tilemaps/coldfire/ColdFireYellow.tscn")

var coldfire_dark = Color8(70, 66, 94)
var coldfire_blue = Color8(91, 118, 141)
var coldfire_red = Color8(209, 124, 124)
var coldfire_yellow = Color8(246, 198, 168)

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

######################################################################
# room data

func get_groups():
	var groups = [
		[
			MapGroup.new(coldfire_dark, dark_tile_scene, 0.0, 0.4),
			MapGroup.new(coldfire_blue, blue_tile_scene, 0.4, 0.7),
			],
		[
			MapGroup.new(coldfire_dark, dark_tile_scene, 0.0, 0.4),
			MapGroup.new(coldfire_red, red_tile_scene, 0.4, 0.7),
			],
		[
			MapGroup.new(coldfire_dark, dark_tile_scene, 0.0, 0.4),
			MapGroup.new(coldfire_yellow, yellow_tile_scene, 0.4, 0.7),
		]
		]
	return groups[randi() % groups.size()]

func get_noise_input():
	var options = [{
		"seed": Util._or(seed_override, 1001),
		"octaves": 4,
		"period": 30,
		"persistence": 0.4,
		"lacunarity": 2.0,
		"img_size": img_size
	}, {
		"seed": Util._or(seed_override, 1002),
		"octaves": 3,
		"period": 10,
		"persistence": 0.3,
		"lacunarity": 2.0,
		"img_size": img_size
	}]

	return options[randi() % options.size()]


######################################################################
# ready

var ready = false
func _ready():
	ready = true

var rooms = []

######################################################################
# inputs

export(String) var room_name = "Room"
export(int) var img_size = 30
export(int) var seed_override

######################################################################
# triggers

export(bool) var clear setget do_clear
func do_clear(_v):
	if ready:
		for c in get_children():
			c.queue_free()
		rooms = []

export(String, "above", "below", "left", "right") var next_room_dir = "right" setget set_next_room_dir
func set_next_room_dir(val):
	next_room_dir = val

func get_next_room_position(next_room):
	# TODO alert when pointing at an existing room?
	var next_position = Vector2.ZERO
	var last_room = rooms.pop_back()
	if last_room:
		next_position = last_room.global_position
		match(next_room_dir):
			"above": next_position.y -= next_room.height()
			"below": next_position.y += next_room.height()
			"left": next_position.x -= next_room.width()
			"right": next_position.x += next_room.width()
	return next_position

export(bool) var add_room setget do_add_room
func do_add_room(_v):
	if ready:
		gen_new_room()

######################################################################
# gen new map

func gen_new_room():
	print("-----------------------")
	prn("Creating room ", room_name)

	var room = MapRoom.new()
	room.set_room_name(room_name)

	var room_opts = {}
	room_opts.merge(get_noise_input())
	room.set_data(room_opts)
	room.groups = get_groups()
	room.position_offset = get_next_room_position(room)

	add_child(room)
	room.set_owner(self)

	room.regen_tilemaps()

	rooms.append(room)
