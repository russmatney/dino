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

func _ready():
	init_grid()

func all_cell_coords():
	var cs := []
	for x in range(width):
		for y in range(height):
			 cs.append(Vector2(x, y))
	return cs

onready var cells = $Cells

func init_grid(anim = "yellow"):
	for c in cells.get_children():
		if c.is_in_group("cells"):
			c.free()

	for cs in all_cell_coords():
		var c = cell_scene.instance()
		c.anim = anim
		c.frame = randi() % 4
		c.position = cs * cell_size
		cells.add_child(c)
		c.set_owner(self)
