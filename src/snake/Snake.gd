tool
extends Node2D
class_name Snake

###########################################################################
# ready

var hud_scene = preload("res://src/snake/hud/HUD.tscn")

func _ready():
	if not Engine.editor_hint:
		SnakeSounds.play_song("field-stars")

		Cam.ensure_camera(2, 1000.0, 1)
		Hood.ensure_hud(hud_scene)

	var _x = connect("step", self, "_on_step")
	var _y = connect("move_head", self, "_on_move_head")

##########################################################################
# move

var move_dir_queue = []

func move(dir):
	move_dir_queue.append(dir)


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

var should_flash

func draw_segment(coord):
	var c = cell_scene.instance()
	if should_flash:
		c.set_animation("flash")
		c.playing = true
	else:
		c.set_animation("dark")
	c.frame = randi() % 4
	c.global_position = grid.coord_to_position(coord)
	c.coord = coord
	grid.add_child(c)
	segments[coord] = c

###########################################################################
# snake segment helpers

func head_cell():
	return segments[segment_coords[0]]

func tail_cells():
	var ts = []
	for coord in segment_coords.slice(1, -1):
		ts.append(segments[coord])
	return ts

func print_snake_meta():
	var hc = head_cell()
	print("head cell pos: ", hc.coord, " ", hc.position, " ", hc.global_position)
	for t in tail_cells():
		print("tail cell pos: ", t.coord, " ", t.position, " ", t.global_position)


###########################################################################
# process

export(float) var walk_every = 0.3
var secs_til_walk = 0.3

func walk_in_t(delta):
	secs_til_walk -= delta
	if secs_til_walk <= 0:
		secs_til_walk = walk_every
		walk_in_dir()

func process(delta):
	if not Engine.editor_hint:
		walk_in_t(delta)

func _process(delta):
	# avoid calling parent process AND child process
	process(delta)

###########################################################################
# walk

func walk_in_dir(dir=null):
	if not dir and move_dir_queue.size():
		var next_dir = move_dir_queue.pop_front()
		if next_dir + direction != Vector2.ZERO:
			direction = next_dir
		else:
			# moving against current direction
			# TODO switch head to tail? stop in place?
			Cam.screenshake(0.3)

	if dir:
		direction = dir

	if segment_coords:
		# calc next coord with direction and current head
		var next = segment_coords[0] + direction
		next = grid.wrap_edges(next)
		attempt_walk(next)

var step_count = 0
signal step

func attempt_walk(next):
	var info = grid.cell_info_at(next, head_cell().coord)

	match info:
		"snake":
			SnakeSounds.play_sound("bump")
			# TODO debounce this notif
			highlight("[jump]ow!")
		_:
			walk_towards(next)

func _on_step():
	step_count +=1

func walk_towards(next, should_drop_tail = true):
	emit_signal("step")
	if should_drop_tail:
		drop_tail()
	move_head(next)

func drop_tail():
	var tail = segment_coords.pop_back()
	var c = segments[tail]
	segments.erase(tail)
	c.queue_free()

func _on_move_head(_coord):
	bounce_head()

signal move_head(coord)
func move_head(coord):
	segment_coords.push_front(coord)
	draw_segment(coord)
	global_position = head_cell().global_position
	emit_signal("move_head", coord)

##################################################################
# highlight

var text_highlight_scene = preload("res://src/snake/TextHighlight.tscn")

func highlight(text):
	var th = text_highlight_scene.instance()
	th.bbcode_text = text
	th.set_global_position(global_position)
	Navi.add_child_to_current(th)

	var tween = create_tween()
	th.set_scale(Vector2.ZERO)
	tween.tween_property(th, "rect_scale", 0.5*Vector2.ONE, 0.5).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(th, "rect_scale", Vector2.ZERO, 0.2).set_ease(Tween.EASE_IN_OUT)

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
