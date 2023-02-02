tool
extends Node2D

###########################################################################
# exports/vars

export(int, 2, 24) var width = 16 setget set_width
export(int, 2, 24) var height = 16 setget set_height
export(int) var cell_size = 8 setget set_cell_size


func set_width(v):
	width = v
	if Engine.editor_hint and ready:
		init_grid()


func set_height(v):
	height = v
	if Engine.editor_hint and ready:
		init_grid()


func set_cell_size(v):
	cell_size = v
	if Engine.editor_hint and ready:
		init_grid()


###########################################################################
# ready


var ready
func _ready():
	call_deferred("setup")
	ready = true


func setup():
	init_grid()
	init_snake()
	init_food()


###########################################################################
# grid


func all_cell_coords():
	var cs := []
	for x in range(width):
		for y in range(height):
			cs.append(Vector2(x, y))
	return cs


func random_coord():
	var all = all_cell_coords()
	return all[randi() % all.size()]


func random_empty_coord(exclude=null):
	var coords = all_cell_coords()
	for c in snake.cell_coords:
		coords.erase(c)
	for f in food:
		coords.erase(f.coord)
	if exclude:
		coords.erase(exclude)
	if coords:
		return Util.rand_of(coords)


###########################################################################
# cells


# dicts for cells might be better here
func cell_info_at(coord):
	for c in snake.cell_coords:
		if coord == c:
			return "snake"

	for f in food:
		if coord == f.coord:
			return ["food", f]

	for c in all_cell_coords():
		if coord == c:
			return "empty"


func mark_touched(coord):
	var cell = cells[coord]
	if cell:
		cell.animation = "blue"
		# TODO dry up 'random frame' on animations with a util
		cell.frame = randi() % 4

###########################################################################
# init grid

onready var cell_scene = preload("res://src/snake/Cell.tscn")
var cells = {}


func init_grid(anim = "yellow"):
	for c in $Cells.get_children():
		if c.is_in_group("cells"):
			c.free()

	for coord in all_cell_coords():
		var c = cell_scene.instance()
		c.coord = coord
		c.animation = anim
		c.frame = randi() % 4
		c.position = coord * cell_size
		$Cells.add_child(c)

		cells[coord] = c


###########################################################################
# init snake

var snake
onready var snake_scene = preload("res://src/snake/Snake.tscn")


func init_snake():
	if snake:
		snake.free()
	if get_node_or_null("Snake"):
		$Snake.free()

	var initial_cell = random_coord()
	var initial_direction = Vector2.RIGHT
	snake = snake_scene.instance()
	snake.init(self, initial_cell, initial_direction)
	snake.position = initial_cell * cell_size
	add_child(snake)
	snake.draw_segments()


###########################################################################
# init food

var food = []


func init_food():
	for f in food:
		f.free()
	for f in get_children():
		if f.is_in_group("food"):
			f.free()

	add_food()


func add_food(exclude=null):
	var empty_cell = random_empty_coord(exclude)
	if empty_cell == null:
		print("[SNAKE] No empty cells! Cannot place food.")
		return

	var f = cell_scene.instance()
	f.add_to_group("food")
	f.coord = empty_cell
	f.animation = "red"
	f.frame = randi() % 4
	f.position = empty_cell * cell_size
	add_child(f)
	food.append(f)


func remove_food(f):
	food.erase(f)
	f.queue_free()
