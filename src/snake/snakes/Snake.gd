@tool
extends Node2D
class_name Snake

###########################################################################
# ready

var hud_scene = preload("res://src/snake/hud/HUD.tscn")

func _ready():
	step.connect(_on_step)
	move_head.connect(_on_move_head)

##########################################################################
# move

var move_dir_queue = []

func move(dir):
	move_dir_queue.append(dir)


###########################################################################
# init

@export var initial_size: int = 3

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

###########################################################################
# draw/animate segments

@onready var cell_scene = preload("res://src/snake/snakes/Cell.tscn")

var should_flash
var cell_anim = "dark"
var cell_head_anim = "enemyhead"

func draw_segment(coord):
	var c = cell_scene.instantiate()
	if should_flash:
		c.set_animation("flash")
		c.playing = true
	else:
		c.set_animation(cell_anim)
	Util.set_random_frame(c)
	c.global_position = grid.coord_to_position(coord)
	c.coord = coord
	grid.add_child(c)
	segments[coord] = c

func animate_head(cell):
	cell.set_animation(cell_head_anim)
	cell.playing = true
	# TODO grow/lunge per step
	match direction:
		Vector2.LEFT:
			cell.flip_h = true
			cell.rotation = 0
		Vector2.RIGHT:
			cell.flip_h = false
			cell.rotation = 0
		Vector2.UP:
			cell.flip_h = false
			cell.rotation = -PI/2
		Vector2.DOWN:
			cell.flip_h = false
			cell.rotation = PI/2
		_:
			pass

func restore_tail_segment(cell):
	cell.set_animation(cell_anim)
	Util.set_random_frame(cell)
	cell.playing = false

func restore_segments():
	var hd = head_cell()
	if is_instance_valid(hd):
		animate_head(hd)

	for cell in tail_cells():
		if is_instance_valid(cell):
			restore_tail_segment(cell)

##################################################################
# flashing colors

func cell_flash(cell):
	cell.set_animation("flash")
	Util.set_random_frame(cell)
	cell.playing = true

func segments_flash_white():
	for cell in segments.values():
		if is_instance_valid(cell):
			cell_flash(cell)

###########################################################################
# snake segment helpers

func head_cell():
	if not segment_coords:
		print("no segment coords, can't get head")
		return
	elif not segment_coords[0] in segments:
		print("first segment coord not in segments")
		return

	var hd = segments[segment_coords[0]]
	if is_instance_valid(hd):
		return hd
	else:
		print("head cell invalid")

func tail_cells():
	if segment_coords.size() <= 1:
		return []
	var ts = []
	for coord in segment_coords.slice(1, -1):
		if coord in segments:
			var t = segments[coord]
			if is_instance_valid(t):
				ts.append(t)
			else:
				print("tail cell invalid")
		else:
			print("[WARN] tail coord not in segments")
	return ts

func print_snake_meta():
	var hc = head_cell()
	if hc:
		print("head cell pos: ", hc.coord, " ", hc.position, " ", hc.global_position)
	for t in tail_cells():
		if t:
			print("tail cell pos: ", t.coord, " ", t.position, " ", t.global_position)


###########################################################################
# process

@export var walk_every: float = 0.3
var secs_til_walk = 0.3

func walk_in_t(delta):
	secs_til_walk -= delta
	if secs_til_walk <= 0:
		secs_til_walk = walk_every
		walk_in_dir()

func process(delta):
	walk_in_t(delta)

func _process(delta):
	if not Engine.is_editor_hint() and not dead:
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

	animate_head(head_cell())
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
		["snake", _]:
			var s = info[1]
			if s == self:
				SnakeSounds.play_sound("bump")
				highlight("[jump]ow!")
			else:
				# TODO enemies only chomp player
				# reverse direction when two enemies interact?
				highlight("[jump]chomp!")
				chomp_snake(s, next)
		_:
			walk_towards(next)
	restore_segments()

func _on_step():
	step_count += 1

func walk_towards(next, should_drop_tail = true):
	emit_signal("step")
	if should_drop_tail:
		drop_tail()
	move_head(next)

func drop_tail():
	var tail = segment_coords.pop_back()
	if tail in segments:
		var c = segments[tail]
		segments.erase(tail)
		if is_instance_valid(c):
			c.queue_free()
	else:
		print("[WARN] tail expected but not found in `segments`")

func _on_move_head(_coord):
	bounce_head()

signal move_head(coord)
func move_head(coord):
	segment_coords.push_front(coord)
	draw_segment(coord)
	global_position = head_cell().global_position
	emit_signal("move_head", coord)

##################################################################
# death

signal destroyed(snake)
var dead

func destroy():
	if dead:
		return
	highlight("DEATH")
	dead = true
	segments_flash_white()

	for cell in segments.values():
		if is_instance_valid(cell):
			cell.kill()

	emit_signal("destroyed", self)

	await get_tree().create_timer(2.0).timeout
	# after cells animate away
	queue_free()

##################################################################
# chomp

func duplicate_snake(snake, coord):

	# split passed snake in two
	var dupe = snake.duplicate()

	var coord_idx = snake.segment_coords.find(coord)
	var snake_coords = snake.segment_coords.slice(0, coord_idx)
	var dupe_coords = snake.segment_coords.slice(coord_idx, -1)

	# remove_at chomped square
	snake.segment_coords.erase(coord)
	snake.segments.erase(coord)
	dupe_coords.erase(coord)
	dupe.segments = snake.segments.duplicate()
	dupe.segments.erase(coord)

	# remove_at dead cells from snake
	for d_coord in dupe_coords:
		snake.segment_coords.erase(d_coord)
		snake.segments.erase(d_coord)

	# remove_at 'living' cells from dupe snake
	for s_coord in snake_coords:
		dupe.segments.erase(s_coord)

	dupe_coords.reverse()
	dupe.segment_coords = dupe_coords
	dupe.direction = -1 * snake.direction
	dupe.grid = snake.grid
	grid.add_child(dupe)

func chomp_snake(snake, coord):
	snake.destroy()

	# if snake.head_cell().coord == coord:
	# 	snake.destroy()
	# else:
	# 	duplicate_snake(snake, coord)

	walk_towards(coord)

##################################################################
# highlight

var text_highlight_scene = preload("res://src/snake/TextHighlight.tscn")

func highlight(text):
	var th = text_highlight_scene.instantiate()
	th.text = text
	th.set_global_position(global_position)
	Navi.add_child_to_current(th)

	var tween = create_tween()
	th.set_scale(Vector2.ZERO)
	tween.tween_property(th, "scale", 0.5*Vector2.ONE, 0.5).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(th, "scale", Vector2.ZERO, 0.2).set_ease(Tween.EASE_IN_OUT)

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
