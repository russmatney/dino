# Player.gd
tool
extends Snake

###########################################################################
# ready

func _ready():
	var _x = connect("food_picked_up", self, "_on_food_picked_up")
	var _y = connect("slowmo_start", self, "_on_slowmo_start")
	var _z = connect("slowmo_stop", self, "_on_slowmo_stop")

func print_snake_meta():
	.print_snake_meta()
	print("food: ", food_count)
	print("speed level: ", speed_level)

###########################################################################
# process

var slow_steps_before_pause = 2
var steps_til_stop

func process(delta):
	if slowing_down:
		if steps_til_stop == null:
			steps_til_stop = slow_steps_before_pause
		elif steps_til_stop > 0:
			var stepped = walk_in_t(delta)
			if stepped:
				steps_til_stop -= 1
		else:
			walk_manually = true
	elif not Engine.editor_hint:
		walk_in_t(delta)

## slowmo

signal slowmo_start
signal slowmo_stop

var slowing_down
var walk_manually

func _on_slowmo_start():
	slowing_down = true
	walk_manually = false
	steps_til_stop = slow_steps_before_pause

	Hood.notif("Slooooooow mooooootion")

	Cam.start_slowmo("snake_slowmo", 0.3)

	# TODO need special rules zoom for slowmo, allow us to go below minimum zoom
	old_zoom_level = Cam.cam.zoom_level
	Cam.zoom_in(2)
	# TODO sound

func _on_slowmo_stop():
	slowing_down = false
	walk_manually = false
	Hood.notif("Back to full speed")
	Cam.stop_slowmo("snake_slowmo")
	Cam.zoom_out(old_zoom_level)
	# TODO sound


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
		emit_signal("slowmo_start")
	elif Trolley.is_event_released(event, "slowmo"):
		emit_signal("slowmo_stop")

func move(dir):
	if walk_manually:
		walk_in_dir(dir)
	else:
		move_dir_queue.append(dir)

###########################################################################
# walk

var food_count = 0
signal food_picked_up

func attempt_walk(next):
	var info = grid.cell_info_at(next, head_cell().coord)

	match info:
		["facing_food", _]:
			# TODO move behind combo/level/unlock wall?
			leap_towards_food(next, info[1])
		["food", _]:
			walk_towards(next, false)
			pickup_food(info[1])
		"snake":
			SnakeSounds.play_sound("bump")
			# TODO debounce this notif
			highlight("[jump]ow!")
		_:
			walk_towards(next)

func _on_step():
	._on_step()
	bounce_food()
	SnakeSounds.play_sound("walk")

func _on_move_head(coord):
	._on_move_head(coord)
	attempt_collect(coord)
	grid.mark_touched(coord)

##################################################################
# combo

var combo_juice = 0
signal inc_combo_juice(combo_juice)

func attempt_collect(coord):
	var c = grid.get_cell(coord)
	if c.has_method("should_inc_juice") and c.should_inc_juice():
		highlight("[jump]juice++")
		combo_juice += 1
		emit_signal("inc_combo_juice", combo_juice)
		Hood.notif(str("[jump]Combo Juice ++: ", combo_juice))

##################################################################
# leap

func leap_towards_food(next, f):
	# first, take the step onto the food's row/col
	walk_towards(next)

	var target_cell = grid.wrap_edges(f.coord - direction)
	var next_cell = head_cell().coord
	if target_cell != next_cell:
		# walk to target cell
		for _i in range(100):
			next_cell += direction
			next_cell = grid.wrap_edges(next_cell)
			var info = grid.cell_info_at(next_cell)

			match info:
				"snake":
					SnakeSounds.play_sound("bump")
					highlight("[jump]derp.")
					return
				_:
					walk_towards(next_cell)
					if next_cell == target_cell:
						break

	pickup_food(f)
	walk_towards(f.coord, false)

##################################################################
# food picked up

func pickup_food(f):
	food_count += 1
	emit_signal("food_picked_up", f)

signal speed_increased

var speed_level = 1

func _on_food_picked_up(f):
	var txt = Util.rand_of(["[jump]Am nam nam[/jump]", "[jump]Yummy![/jump]"])
	Hood.notif(txt, {"rich": true})
	SnakeSounds.play_sound("pickup")
	bounce_tail()
	bounce_floor()

	highlight(txt)

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