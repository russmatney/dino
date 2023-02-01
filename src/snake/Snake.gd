tool
extends Node2D

export(int) var initial_size = 3

func _ready():
	pass

var cell_coords = []

func init(cell: Vector2, dir: Vector2, size := initial_size):
	cell_coords.append(cell)
	var next_cell = cell
	for _i in range(size - 1):
		next_cell -= dir
		cell_coords.append(next_cell)

