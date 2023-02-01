tool
extends Node2D

export(int) var initial_size = 3

###########################################################################
# input


func _unhandled_input(event):
	if Trolley.is_event(event, "move_right"):
		move(Vector2.RIGHT)
	elif Trolley.is_event(event, "move_left"):
		move(Vector2.LEFT)
	elif Trolley.is_event(event, "move_up"):
		move(Vector2.UP)
	elif Trolley.is_event(event, "move_down"):
		move(Vector2.DOWN)


var move_dir_queue = []


func move(dir):
	# TODO expose juicy direction queue append
	move_dir_queue.append(dir)


###########################################################################
# ready


func _ready():
	Cam.ensure_camera(2)


###########################################################################
# init

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


###########################################################################
# start/walk

export(float) var walk_every = 0.15

var walk_tween


func restart():
	walk_tween = create_tween()
	walk_tween.set_loops()
	walk_tween.tween_callback(self, "walk_in_dir").set_delay(walk_every)


func walk_in_dir():
	if move_dir_queue.size():
		# update direction
		var next_dir = move_dir_queue.pop_front()
		if next_dir + direction != Vector2.ZERO:
			# ignore moving against current direction
			direction = next_dir

	var next = cell_coords[0] + direction
	next.x = wrapi(next.x, 0, grid.width)
	next.y = wrapi(next.y, 0, grid.height)

	handle_next_walk(next)


var food = 0


func handle_next_walk(next):
	var info = grid.cell_info_at(next)

	match info:
		["food", _]:
			food += 1
			grid.remove_food(info[1])

			# hitstop here needs alot more juice
			# Cam.hitstop("snake_collecting_food", 0.01, 0.3, 0.2)
			Cam.screenshake(0.3)

			# pass next to exclude it from new food places
			grid.add_food(next)
			if food % 3 == 0:
				walk_every -= walk_every * 0.05
				restart()
				Cam.screenshake(0.5)
			walk_towards(next, false)
		"snake":
			print("TODO game over")
		_:
			walk_towards(next)


func walk_towards(next, drop_tail = true):
	if drop_tail:
		var tail = cell_coords.pop_back()
		var c = segments[tail]
		segments.erase(tail)
		c.queue_free()

	cell_coords.push_front(next)
	draw_segment(next)
