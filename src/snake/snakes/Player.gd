# Player.gd
@tool
extends Snake

###########################################################################
# ready

func _ready():
	if not Engine.is_editor_hint():
		Cam.ensure_camera()
		Hood.ensure_hud(hud_scene)

	var _x = food_picked_up.connect(_on_food_picked_up)
	var _y = slowmo_start.connect(_on_slowmo_start)
	var _z = slowmo_stop.connect(_on_slowmo_stop)

	cell_anim = "player"
	cell_head_anim = "playerhead"

func print_snake_meta():
	super.print_snake_meta()
	Debug.pr("food: ", food_count)
	Debug.pr("speed level: ", speed_level)

###########################################################################
# physics_process

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
	else:
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
		slowmo_start.emit()
	elif Trolley.is_event_released(event, "slowmo"):
		slowmo_stop.emit()

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
			restore_segments()
		["snake", _]:
			var s = info[1]
			if s == self:
				SnakeSounds.play_sound("bump")
				highlight("[jump]ow!")
			else:
				highlight("[jump]chomp!")
				chomp_snake(s, next)
			restore_segments()
		_:
			walk_towards(next)
			restore_segments()

func _on_step():
	if not leaping:
		# TODO skipping step counter here
		super._on_step()
	bounce_food()
	SnakeSounds.play_sound("walk")

func _on_move_head(coord):
	if not dead:
		super._on_move_head(coord)
		# ... in case we lost in the middle of this?
		if is_instance_valid(grid):
			attempt_collect(coord)
			grid.mark_touched(coord)

##################################################################
# combo

var combo_juice = 0
signal inc_combo_juice(combo_juice)

func attempt_collect(coord):
	var c = grid.get_cell(coord)
	if c and c.has_method("should_inc_juice") and c.should_inc_juice():
		highlight("[jump]juice++")
		combo_juice += 1
		inc_combo_juice.emit(combo_juice)
		# Hood.notif(str("[jump]Combo Juice ++: ", combo_juice))

##################################################################
# leap

var leaping

func leap_towards_food(next, f):
	highlight("LEAP")
	should_flash = true
	leaping = true
	segments_flash_white()
	Cam.screenshake(0.1)
	SnakeSounds.play_sound("laser")

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
				["snake", _]:
					var s = info[1]
					if s == self:
						SnakeSounds.play_sound("bump")
						highlight("[jump]ow!")
						highlight("[jump]derp.")
					else:
						highlight("[jump]chomp!")
						chomp_snake(s, next)
					should_flash = false
					restore_segments()
					return
				_:
					# TODO skip steps in this walk (b/c we leap)
					walk_towards(next_cell)
					if next_cell == target_cell:
						break

	pickup_food(f)
	walk_towards(f.coord, false)

	should_flash = false
	leaping = false

	await get_tree().create_timer(0.4).timeout
	restore_segments()

##################################################################
# food picked up

func pickup_food(f):
	food_count += 1
	food_picked_up.emit(f)

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
		speed_increased.emit()
		SnakeSounds.play_sound("speedup")

		# TODO move to combo levels
		grid.mark_cells_playing()
		await get_tree().create_timer(3.0).timeout
		grid.mark_cells_not_playing()
