tool
extends Node

func _ready():
	if OS.has_feature("harvey"):
		Navi.set_main_menu("res://src/harvey/menus/HarveyMenu.tscn")
		Navi.set_pause_menu("res://src/harvey/menus/HarveyPauseMenu.tscn")

	time_up_container = CanvasLayer.new()
	time_up_menu = time_up_menu_scene.instance()
	time_up_container.add_child(time_up_menu)
	call_deferred("add_child", time_up_container)

#########################################################################
# restart

func restart_game():
	Navi.resume() # ensure unpaused
	Navi.nav_to("res://src/harvey/maps/KitchenSink.tscn")

#########################################################################
# time up

var time_up_menu_scene = preload("res://src/harvey/menus/TimeUpMenu.tscn")
var time_up_container
var time_up_menu

func time_up(produce_counts):
	var t = get_tree()
	t.paused = true
	DJ.resume_menu_song()
	time_up_menu.show()
	time_up_menu.set_score(produce_counts)

#########################################################################
# dev mode

func debug_mode():
	# OS.is_debug_build()
	return false

signal new_produce_delivered(type)

func new_produce_delivered(type):
	emit_signal("new_produce_delivered", type)
