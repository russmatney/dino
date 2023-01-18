tool
extends Node2D

var dark_tile_scene = preload("res://addons/reptile/tilemaps/coldfire/ColdFireDark.tscn")
var blue_tile_scene = preload("res://addons/reptile/tilemaps/coldfire/ColdFireBlue.tscn")
var red_tile_scene = preload("res://addons/reptile/tilemaps/coldfire/ColdFireRed.tscn")
var yellow_tile_scene = preload("res://addons/reptile/tilemaps/coldfire/ColdFireYellow.tscn")

var coldfire_dark = Color(70, 66, 94)
var coldfire_blue = Color(91, 118, 141)
var coldfire_red = Color(209, 124, 124)
var coldfire_yellow = Color(246, 198, 168)

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
# inputs

func inputs(opts={}):
	# ensures some defaults
	# merge does not overwrite values for existing keys
	opts.merge({
		"seed": 1001,
		"octaves": 4,
		"period": 20,
		"persistence": 0.6,
		"lacunarity": 3.0,
		"img_size": 20,
		})
	return opts

######################################################################
# triggers

export(bool) var clear setget do_clear
func do_clear(_v):
	if ready:
		for c in get_children():
			c.queue_free()

export(bool) var add_map setget do_add_map
func do_add_map(_v):
	if ready:
		gen_new_map()

######################################################################
# gen new map

func gen_new_map():
	print("-----------------------")
	prn(str("Adding map", Time.get_unix_time_from_system()))

	var next_position = Vector2(offset_x, 0)
	prn(str("next position: ", next_position))

	var img_size = 50
	var cell_size = 64

	var inps = inputs({
		"img_size": img_size,
		"cell_size": cell_size,
		"gen_node_position": next_position,
		})
	var groups = [
		MapGen.MapGroup.new(coldfire_dark, dark_tile_scene, 0.0, 0.4),
		MapGen.MapGroup.new(coldfire_blue, blue_tile_scene, 0.4, 0.7),
		]

	var mg = MapGen.new(inps, groups)

	# Add to scene
	mg.name = "MapGenTowerStart"
	add_child(mg)
	mg.set_owner(self)

	mg.regenerate_image()

	offset_x += cell_size * img_size
