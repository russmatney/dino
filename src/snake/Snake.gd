tool
extends Node2D

export(int) var initial_size = 3

func _ready():
	pass

var cell_coords = []
var segments = {}
var direction
var grid

func init(g, cell: Vector2, dir: Vector2, size := initial_size):
	grid = g
	direction = dir
	cell_coords.append(cell)
	var next_cell = cell
	for _i in range(size - 1):
		next_cell -= direction
		cell_coords.append(next_cell)

onready var cell_scene = preload("res://src/snake/Cell.tscn")

func draw_segments():
	for c in get_children():
		if c.is_in_group("cells"):
			c.free()

	for coord in cell_coords:
		draw_segment(coord)

func draw_segment(coord):
	var c = cell_scene.instance()
	c.animation = "dark"
	c.frame = randi() % 4
	c.position = coord * grid.cell_size - position
	add_child(c)
	c.set_owner(self)
	segments[coord] = c

export(float) var walk_every = 0.5

func start():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_callback(self, "walk").set_delay(walk_every)

func walk():
	var next = cell_coords[0] + direction
	next.x = wrapi(next.x, 0, grid.width)
	next.y = wrapi(next.y, 0, grid.height)

	var tail = cell_coords.pop_back()
	var c = segments[tail]
	segments.erase(tail)
	c.queue_free()

	cell_coords.push_front(next)
	draw_segment(next)
