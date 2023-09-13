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

	match true:
		keep_controls_hidden: restart_fade_in_controls_tween()
		is_restart_held: pass

## update ########################################################

var last_puzzle_update

func _on_entry_updated(entry):
	last_puzzle_update = entry

	update_level_number(entry)
	update_level_message(entry)
	update_dots_remaining(entry)

## level number ########################################################

func update_level_number(entry):
	level_num_label.text = "[center]#%s/n[/center]" % entry.level_number

## message ########################################################

func update_level_message(entry):
	level_message_label.text = "[center]%s[/center]" % entry.level_message

## dots remaining ########################################################

func update_dots_remaining(entry):
	dots_remaining_label.text = "[center]%s/%s dots[/center]" % [entry.dots_remaining, entry.dots_total]

## controls ########################################################

func all_controls():
	return [move_label, undo_label, reset_label]

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
