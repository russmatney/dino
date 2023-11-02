extends Node2D

@onready var hud = $HUD

## ready ########################################################################

var time_up_menu_scene = preload("res://src/harvey/menus/TimeUpMenu.tscn")
var time_up_menu

func _ready():
	time_up_menu = Navi.add_menu(time_up_menu_scene)

	# probably flaky, but works for now
	for ch in get_children():
		if ch.has_signal("produce_delivered"):
			ch.produce_delivered.connect(_on_produce_delivered)

	setup()

func setup():
	# reset data
	produce_counts = {}
	time_remaining = initial_time_remaining

	# start timer
	tick_timer()

## produce counts ########################################################################

var produce_counts = {}

func inc_produce_count(type):
	if type in produce_counts:
		produce_counts[type] = produce_counts[type] + 1
	else:
		produce_counts[type] = 1

	if hud and is_instance_valid(hud):
		hud.update_produce_counts(produce_counts)

## timer ########################################################################

var initial_time_remaining = 90
var time_remaining
func tick_timer():
	if hud and is_instance_valid(hud):
		hud.update_time_remaining(time_remaining)

	if time_remaining <= 0:
		time_up()
	else:
		var tween = create_tween()
		tween.tween_callback(tick_timer).set_delay(1.0)
		time_remaining = time_remaining - 1

## time up ########################################################################

func time_up():
	var t = get_tree()
	t.paused = true
	DJ.resume_menu_song()
	Navi.show_menu(time_up_menu)
	time_up_menu.set_score(produce_counts)

## new produce #######################################################################

func _on_produce_delivered(type):
	DJZ.play(DJZ.S.complete)
	inc_produce_count(type)
