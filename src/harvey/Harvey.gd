@tool
extends DinoGame

var hud

## ready ########################################################################

var time_up_menu

func _ready():
	main_menu_scene = load("res://src/harvey/menus/HarveyMenu.tscn")
	pause_menu_scene = load("res://src/harvey/menus/HarveyPauseMenu.tscn")

	var time_up_menu_scene = load("res://src/harvey/menus/TimeUpMenu.tscn")
	time_up_menu = Navi.add_menu(time_up_menu_scene)

## register ########################################################################

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/harvey")

func register():
	register_menus()


## start ########################################################################

func start():
	Navi.nav_to("res://src/harvey/maps/KitchenSink.tscn")
	Navi.hide_menus()

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

	if hud:
		hud.update_produce_counts(produce_counts)

## timer ########################################################################

var initial_time_remaining = 90
var time_remaining
func tick_timer():
	if hud:
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

signal new_produce_delivered(type)

func produce_delivered(type):
	DJZ.play(DJZ.S.complete)
	inc_produce_count(type)
