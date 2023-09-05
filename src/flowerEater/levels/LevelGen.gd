@tool
extends Node2D

@export_file var puzz_file: String
@export var square_size: int = 64
@export var level_num: int = 0

var game_def
var level_script = preload("res://src/flowerEater/levels/Level.gd")

func _ready():
	game_def = Puzz.parse_game(puzz_file)
	Debug.pr("Found", len(game_def.levels), "levels")

	generate_level(level_num)

func generate_level(num=0):
	var level_node_name = "Level_%s" % num
	for ch in get_children():
		if ch.name == level_node_name:
			ch.free()

	var level_node = Node2D.new()
	level_node.name = level_node_name
	level_node.set_script(level_script)
	level_node.game_def = game_def
	level_node.level_def = game_def.levels[num]
	level_node.square_size = square_size
	add_child(level_node)
	level_node.set_owner(self)
