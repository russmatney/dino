@tool
extends Node2D

@export_file var puzz_file: String
@export var square_size: int = 64
@export var level_num: int = 0

var game


func _ready():
	game = Puzz.parse_game(puzz_file)
	Debug.pr("Found", len(game.levels), "levels")

	Debug.pr("first level", game.levels[0])
	Debug.pr("game legend", game.legend)

	generate_level(level_num)

func generate_level(num=0):
	var level_node_name = "level%s" % num
	for ch in get_children():
		if ch.name == level_node_name:
			ch.free()

	var level_node = Node2D.new()
	level_node.name = level_node_name
	add_child(level_node)
	level_node.set_owner(self)

	var level_def = game.levels[num]

	for y in range(len(level_def.shape)):
		for x in range(len(level_def.shape[y])):
			var cell = level_def.shape[y][x]
			add_square(level_node, x, y, cell)

func add_color_rect(node, pos, size, color):
	var crect = ColorRect.new()
	crect.color = color
	crect.position = pos
	crect.size = size
	node.add_child(crect)

func add_square(node, x, y, cell):
	var pos = Vector2(x, y) * square_size
	var size = Vector2.ONE * square_size
	if cell == null:
		add_color_rect(node, pos, size, Color.PERU)
		return

	Debug.pr("would draw x y cell", x, y, cell)

	var objs = Puzz.get_cell_objects(game, cell)
	Debug.pr("with objects", objs)
