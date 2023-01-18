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

var offset_x = 0
var offset_y = 0

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
# ready

var ready = false

func _ready():
	ready = true

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

		offset_x = 0

export(bool) var add_room setget do_add_room
func do_add_room(_v):
	if ready:
		gen_new_room()

######################################################################
# gen new map

func gen_new_room():
	print("-----------------------")

	var next_position = Vector2(offset_x, 0)
	prn("Creating room ", room_name, " ", next_position)

	var room = MapRoom.new()
	room.set_room_name(room_name)
	room.set_data({
		"seed": Util._or(seed_override, 1001),
		"octaves": 4,
		"period": 30,
		"persistence": 0.4,
		"lacunarity": 2.0,
		"img_size": img_size,
		"position_offset": next_position,
		})

	room.groups = [
		MapGroup.new(coldfire_dark, dark_tile_scene, 0.0, 0.4),
		MapGroup.new(coldfire_blue, blue_tile_scene, 0.4, 0.7),
		]

	add_child(room)
	room.set_owner(self)

	room.regen_tilemaps()

	offset_x += room.cell_size * room.img_size
	offset_y += room.cell_size * room.img_size
