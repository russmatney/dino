extends CanvasLayer

## vars ########################################################

@onready var level_num_label = $%LevelNum
@onready var level_message_label = $%LevelMessage
@onready var dots_remaining_label = $%DotsRemaining

@onready var move_label = $%Move
@onready var undo_label = $%Undo
@onready var reset_label = $%Reset

## ready ########################################################

func _ready():
	Hotel.entry_updated.connect(_on_entry_updated)
	var initial_puzzle = Hotel.first({group=DotHop.puzzle_group})
	if initial_puzzle == null:
		Debug.warn("No initial puzzle found!")
	else:
		_on_entry_updated(initial_puzzle)

## unhandled_input ########################################################

func _unhandled_input(event):
	var keep_controls_hidden = Trolley.is_move(event) or Trolley.is_undo(event)
	var is_restart_held = Trolley.is_restart_held(event)
	var is_restart_released = Trolley.is_restart_released(event)

	match true:
		keep_controls_hidden: restart_fade_in_controls_tween()
		is_restart_held: show_resetting()
		is_restart_released: hide_resetting()

## update ########################################################

var last_puzzle_update

func _on_entry_updated(entry):
	last_puzzle_update = entry

	update_level_number(entry)
	update_level_message(entry)
	update_dots_remaining(entry)

## level number ########################################################

func update_level_number(entry):
	if "level_number" in entry:
		level_num_label.text = "[center]#%s/n[/center]" % entry.level_number

## message ########################################################

func update_level_message(entry):
	if "level_message" in entry:
		level_message_label.text = "[center]%s[/center]" % entry.level_message

## dots remaining ########################################################

func update_dots_remaining(entry):
	var total = entry.dots_total
	var found = total - entry.dots_remaining
	dots_remaining_label.text = "[center]%s/%s dots[/center]" % [found, total]

## controls ########################################################

# TODO only show undo after a move has been made
# TODO only show reset after several moves have been made
func all_controls():
	var cts = [move_label, undo_label]
	if not resetting:
		cts.append(reset_label)
	return cts

var fade_controls_tween
func fade_controls():
	if fade_controls_tween != null and fade_controls_tween.is_running():
		return
	fade_controls_tween = create_tween()
	all_controls().map(func(c):
		fade_controls_tween.parallel().tween_property(c, "modulate:a", 0.1, 0.8))

var show_controls_tween
func show_controls():
	show_controls_tween = create_tween()
	all_controls().map(func(c):
		show_controls_tween.parallel().tween_property(c, "modulate:a", 0.9, 0.6))

# could probably just use a timer, but meh
var controls_tween
func restart_fade_in_controls_tween():
	fade_controls()
	if controls_tween != null:
		controls_tween.kill()
	controls_tween = create_tween()
	controls_tween.tween_callback(show_controls).set_delay(3.0)

## restarting ########################################################

var resetting
var reset_tween
func show_resetting():
	var hold_t = DotHop.reset_hold_t
	resetting = true
	reset_label.text = "Keep holding to reset..."

	if reset_tween != null and reset_tween.is_running():
		return
	reset_tween = create_tween()
	reset_tween.tween_property(reset_label, "modulate:a", 1.0, hold_t/0.3)
	reset_tween.parallel().tween_property(reset_label, "scale", 1.3 * Vector2.ONE, hold_t)
	# presumably we're back at the beginning
	reset_tween.tween_callback(hide_resetting)

func hide_resetting():
	resetting = false
	if reset_tween != null:
		reset_tween.kill()

	reset_label.text = "Reset: Hold x/y"
	reset_label.scale = Vector2.ONE
