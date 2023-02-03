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

	elif Trolley.is_event(event, "slowmo"):
		Cam.start_slowmo("snake_slowmo", 0.3)
		# TODO special rules zoom for slowmo, allow us to go below minimum zoom
		Cam.zoom_in()
		# TODO slow mo sound effect mods
		Hood.notif("Slooooooow mooooootion")
	elif Trolley.is_event_released(event, "slowmo"):
		Cam.stop_slowmo("snake_slowmo")
		Cam.zoom_out()
		Hood.notif("Back to full speed")


var move_dir_queue = []


func move(dir):
	# TODO expose juicy direction queue append
	move_dir_queue.append(dir)


###########################################################################
# ready

var hud_scene = preload("res://src/snake/hud/HUD.tscn")


func _ready():
	# SnakeSounds.play_song("cool-kids")
	# SnakeSounds.play_song("chill-electric")
	# SnakeSounds.play_song("evening-dogs")
	# SnakeSounds.play_song("funk-till-five")
	# SnakeSounds.play_song("funkmachine")
	SnakeSounds.play_song("field-stars")

	Cam.ensure_camera(2, 10.0)
	Hood.ensure_hud(hud_scene)


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
# process

export(float) var walk_every = 0.15
var next_walk_in = 0


func _process(delta):
	next_walk_in -= delta
	if next_walk_in <= 0:
		next_walk_in = walk_every
		walk_in_dir()

###########################################################################
# walk

var step_count = 0

func walk_in_dir():
	if move_dir_queue.size():
		# update direction
		var next_dir = move_dir_queue.pop_front()
		if next_dir + direction != Vector2.ZERO:
			# ignore moving against current direction
			direction = next_dir
		else:
			Cam.screenshake(0.5)

	var next = cell_coords[0] + direction
	next.x = wrapi(next.x, 0, grid.width)
	next.y = wrapi(next.y, 0, grid.height)

	attempt_walk(next)

signal food_picked_up
signal speed_increased

var food_count = 0
var speed_level = 1

func handle_pickup_food(next, f):
	Hood.notif(
		Util.rand_of(["[jump]Am nam nam[/jump]", "[jump]Yummy![/jump]"]),
		{"rich": true}
		)
	SnakeSounds.play_sound("pickup")
	bounce_floor()
	food_count += 1
	# must be after inc food_count
	emit_signal("food_picked_up")
	grid.remove_food(f)

	# TODO flash some text, hitstop lines
	Cam.freezeframe("snake_collecting_food", 0.01, 1.6, 0.5)

	# pass next to exclude it from new food places
	grid.add_food(next)

	if food_count % 3 == 0:
		walk_every -= walk_every * 0.1
		Cam.screenshake(0.5)
		speed_level += 1
		emit_signal("speed_increased")
		SnakeSounds.play_sound("speedup")

	walk_towards(next, false)

func attempt_walk(next):
	var info = grid.cell_info_at(next)

	match info:
		["food", _]:
			handle_pickup_food(next, info[1])
		"snake":
			SnakeSounds.play_sound("bump")
			print("TODO game over")
		_:
			walk_towards(next)

signal step

func walk_towards(next, drop_tail = true):
	step_count += 1
	emit_signal("step")
	if drop_tail:
		var tail = cell_coords.pop_back()
		var c = segments[tail]
		segments.erase(tail)
		c.queue_free()

		grid.mark_touched(tail)

	SnakeSounds.play_sound("walk")

	cell_coords.push_front(next)
	draw_segment(next)

	# var c = segments[next]
	# c.bounce(direction.rotated(PI/2), 0.95)

	bounce_segments()
	# bounce_floor()
	bounce_food()

func bounce_segments():
	for cell in segments.values():
		cell.bounce(direction.rotated(PI/2))

func bounce_floor():
	for cell in grid.all_cells():
		cell.bounce(direction)

func bounce_food():
	for cell in grid.food_cells():
		cell.bounce(direction.rotated(PI/2))
