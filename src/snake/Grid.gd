tool
extends Node2D

export(int, 2, 24) var width = 16 setget set_width
export(int, 2, 24) var height = 16 setget set_height
export(int) var cell_size = 8 setget set_cell_size

func set_width(v):
	width = v
	init_grid()

func set_height(v):
	height = v
	init_grid()

func set_cell_size(v):
	cell_size = v
	init_grid()

onready var cell_scene = preload("res://src/snake/Cell.tscn")
onready var snake_scene = preload("res://src/snake/Snake.tscn")

func _ready():
	init_grid()
	init_snake()

func all_cell_coords():
	var cs := []
	for x in range(width):
		for y in range(height):
			 cs.append(Vector2(x, y))
	return cs

func random_coord():
	var all = all_cell_coords()
	return all[randi() % all.size()]

onready var cells = $Cells

func init_grid(anim = "yellow"):
	for c in cells.get_children():
		if c.is_in_group("cells"):
			c.free()

	for coord in all_cell_coords():
		var c = cell_scene.instance()
		c.animation = anim
		c.frame = randi() % 4
		c.position = coord * cell_size
		cells.add_child(c)
		c.set_owner(self)

var snake

func init_snake():
	if snake:
		snake.free()
	if get_node_or_null("Snake"):
		$Snake.free()

	var initial_cell = random_coord()
	var initial_direction = Vector2.RIGHT
	snake = snake_scene.instance()
	snake.init(initial_cell, initial_direction)
	snake.position = initial_cell * cell_size
	add_child(snake)
	snake.set_owner(self)
	print(snake.cell_coords)

	for coord in snake.cell_coords:
		var c = cell_scene.instance()
		c.animation = "dark"
		c.frame = randi() % 4
		c.position = coord * cell_size - snake.position
		snake.add_child(c)
		c.set_owner(self)
