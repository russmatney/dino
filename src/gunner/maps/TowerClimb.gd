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
var ready = false

func _ready():
	ready = true

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

func default_inputs():
	# ensures some defaults
	return {
		"seed": 1001,
		"octaves": 4,
		"period": 20,
		"persistence": 0.6,
		"lacunarity": 3.0,
		"img_size": 20,
		}

func build_room_data():
	var img_size = 50
	var cell_size = 64

	var room_data = {}

	# merge does not overwrite values for existing keys
	room_data.merge({
		"img_size": img_size,
		"cell_size": cell_size,
		})
	room_data.merge(default_inputs())

	var groups = [
		MapGroup.new(coldfire_dark, dark_tile_scene, 0.0, 0.4),
		MapGroup.new(coldfire_blue, blue_tile_scene, 0.4, 0.7),
		]

	room_data.merge({"groups": groups})
	return room_data


######################################################################
# triggers

export(bool) var clear setget do_clear
func do_clear(_v):
	if ready:
		for c in get_children():
			c.queue_free()

		offset_x = 0

export(bool) var add_map setget do_add_map
func do_add_map(_v):
	if ready:
		gen_new_map()


######################################################################
# gen new map

export(String) var room_name = "Room"

# var map_gen_scene = preload("res://addons/reptile/maps/MapGen.tscn")

func gen_new_map():
	print("-----------------------")
	prn(str("Adding map ", Time.get_unix_time_from_system()))

	var next_position = Vector2(offset_x, 0)
	prn(str("next position: ", next_position))

	var room_data = build_room_data()
	room_data["gen_node_position"] = next_position
	# var mg = map_gen_scene.instance()
	var mg = MapGen.new()
	mg.init_room_data(room_data)

	mg.name = "MapGen" + room_name
	mg.gen_node_path = room_name
	add_child(mg)
	mg.set_owner(self)

	mg.regenerate_image()

	offset_x += mg.cell_size * mg.img_size
