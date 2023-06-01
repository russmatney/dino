@tool
extends DinoGame

## ready ########################################################################

func _ready():
	main_menu_scene = load("res://src/harvey/menus/HarveyMenu.tscn")
	pause_menu_scene = load("res://src/harvey/menus/HarveyPauseMenu.tscn")

	# TODO use navi menu support
	time_up_container = CanvasLayer.new()
	time_up_menu = time_up_menu_scene.instantiate()
	time_up_menu.hide()
	time_up_container.add_child(time_up_menu)
	add_child.call_deferred(time_up_container)


## register ########################################################################

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/harvey")

func register():
	register_menus()


## start ########################################################################

func start():
	Navi.nav_to("res://src/harvey/maps/KitchenSink.tscn")


## time up ########################################################################

var time_up_menu_scene = preload("res://src/harvey/menus/TimeUpMenu.tscn")
var time_up_container
var time_up_menu


func time_up(produce_counts):
	var t = get_tree()
	t.paused = true
	DJ.resume_menu_song()
	time_up_menu.show()
	# TODO fix in some centralized way
	Navi.find_focus(time_up_menu)
	time_up_menu.set_score(produce_counts)


## new produce #######################################################################

signal new_produce_delivered(type)

func produce_delivered(type):
	DJZ.play(DJZ.S.complete)
	new_produce_delivered.emit(type)
