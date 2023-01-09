tool
extends Node

func _ready():
	if OS.has_feature("harvey"):
		Navi.set_main_menu("res://src/harvey/menus/HarveyMenu.tscn")
		Navi.set_pause_menu("res://src/harvey/menus/HarveyPauseMenu.tscn")

func restart_game():
	Navi.nav_to("res://src/harvey/maps/KitchenSink.tscn")

func time_up():
	# TODO handle time up
	print("time up!")


func debug_mode():
	# OS.is_debug_build()
	return true

signal new_produce_delivered(type)

func new_produce_delivered(type):
	emit_signal("new_produce_delivered", type)
