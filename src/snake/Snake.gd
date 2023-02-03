tool
extends Node2D

###########################################################################
# input


var old_zoom_level
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
		# TODO need special rules zoom for slowmo, allow us to go below minimum zoom
		old_zoom_level = Cam.cam.zoom_level
		Cam.zoom_in(2)
		# TODO slow mo sound effect mods
		Hood.notif("Slooooooow mooooootion")
	elif Trolley.is_event_released(event, "slowmo"):
		Cam.stop_slowmo("snake_slowmo")
		Cam.zoom_out(old_zoom_level)
		Hood.notif("Back to full speed")


var move_dir_queue = []


func move(dir):
	# TODO expose juicy direction queue append
	move_dir_queue.append(dir)


###########################################################################
# ready

var hud_scene = preload("res://src/snake/hud/HUD.tscn")

func _ready():
	if not Engine.editor_hint:
		# SnakeSounds.play_song("cool-kids")
		# SnakeSounds.play_song("chill-electric")
		# SnakeSounds.play_song("evening-dogs")
		# SnakeSounds.play_song("funk-till-five")
		# SnakeSounds.play_song("funkmachine")
		SnakeSounds.play_song("field-stars")

		Cam.ensure_camera(2, 1000.0, 1)
		Hood.ensure_hud(hud_scene)

	var _x = connect("food_picked_up", self, "_on_food_picked_up")


###########################################################################
# init

export(int) var initial_size = 3

var segment_coords = []
var segments = {}
var direction
var grid


func init(g, cell: Vector2, dir: Vector2, size := initial_size):
	grid = g
	direction = dir

	move_head(cell)
	var next_cell = cell
	for _i in range(size - 1):
		next_cell += direction
		move_head(next_cell)


func clear_cells():
	for c in get_children():
		if c.is_in_group("cells"):
			c.free()

func draw_segments():
	clear_cells()

	for coord in segment_coords:
		draw_segment(coord)


onready var cell_scene = preload("res://src/snake/Cell.tscn")

func draw_segment(coord):
	var c = cell_scene.instance()
	c.animation = "dark"
	c.frame = randi() % 4
	c.global_position = grid.coord_to_position(coord)
	c.coord = coord
	grid.add_child(c)
	segments[coord] = c


###########################################################################
# process

export(float) var walk_every = 0.12
var next_walk_in = 0


func _process(delta):
	if not Engine.editor_hint:
		next_walk_in -= delta
		if next_walk_in <= 0:
			next_walk_in = walk_every
			walk_in_dir()

###########################################################################
# walk

func walk_in_dir():
	if move_dir_queue.size():
		var next_dir = move_dir_queue.pop_front()
		if next_dir + direction != Vector2.ZERO:
			direction = next_dir
		else:
			# moving against current direction
			# TODO switch head to tail? stop in place?
			Cam.screenshake(0.3)

	if segment_coords:
		# calc next coord with direction and current head
		var next = segment_coords[0] + direction
		next = grid.wrap_edges(next)
		attempt_walk(next)

var food_count = 0
var step_count = 0

signal food_picked_up
signal step

func attempt_walk(next):
	# TODO if this direction heads toward food, we should SNAP to it

	var info = grid.cell_info_at(next)

	match info:
		["food", _]:
			food_count += 1
			emit_signal("food_picked_up", info[1])
			walk_towards(next, false)
		"snake":
			SnakeSounds.play_sound("bump")
			print("TODO game over")
		_:
			walk_towards(next)

func walk_towards(next, should_drop_tail = true):
	step_count += 1
	emit_signal("step")

	if should_drop_tail:
		drop_tail()
	move_head(next)

	SnakeSounds.play_sound("walk")
	bounce_food()

func drop_tail():
	var tail = segment_coords.pop_back()
	var c = segments[tail]
	segments.erase(tail)
	c.queue_free()

func move_head(coord):
	segment_coords.push_front(coord)
	draw_segment(coord)
	bounce_head()

	# print_snake_positions()
	global_position = head_cell().global_position
	grid.mark_touched(coord)

func head_cell():
	return segments[segment_coords[0]]

func tail_cells():
	var ts = []
	for coord in segment_coords.slice(1, -1):
		ts.append(segments[coord])
	return ts

func print_snake_positions():
	var hc = head_cell()
	print("head cell pos: ", hc.coord, " ", hc.position, " ", hc.global_position)
	for t in tail_cells():
		print("tail cell pos: ", t.coord, " ", t.position, " ", t.global_position)



##################################################################
# tile bounce helpers

func bounce_head():
	head_cell().bounce_in()

func bounce_tail():
	for t in tail_cells():
		t.bounce(direction.rotated(PI/2))

func bounce_segments():
	for cell in segments.values():
		cell.bounce(direction.rotated(PI/2))

func bounce_floor():
	for cell in grid.all_cells():
		cell.bounce(direction)

func bounce_food():
	for cell in grid.food_cells():
		cell.deform_scale()

##################################################################
# food picked up

signal speed_increased

var speed_level = 1

func _on_food_picked_up(f):
	Hood.notif(
		Util.rand_of(["[jump]Am nam nam[/jump]", "[jump]Yummy![/jump]"]),
		{"rich": true})
	SnakeSounds.play_sound("pickup")
	bounce_tail()
	bounce_floor()

	grid.remove_food(f)

	# TODO flash some text, hitstop lines
	Cam.freezeframe("snake_collecting_food", 0.01, 1.6, 0.2)

	# pass next to exclude it from new food places
	grid.add_food(f.coord)

	if food_count % 3 == 0:
		walk_every -= walk_every * 0.1
		Cam.screenshake(0.3)
		speed_level += 1
		emit_signal("speed_increased")
		SnakeSounds.play_sound("speedup")

		# TODO move to combo levels
		grid.mark_cells_playing()
		yield(get_tree().create_timer(3.0), "timeout")
		grid.mark_cells_not_playing()
