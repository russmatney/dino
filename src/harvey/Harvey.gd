tool
extends Node


func _ready():
	pass # Replace with function body.


func restart_game():
	Navi.nav_to("res://src/harvey/plots/PlotGym.tscn")


func debug_mode():
	# OS.is_debug_build()
	return false

signal new_produce_delivered(type)

func new_produce_delivered(type):
	emit_signal("new_produce_delivered", type)

func time_up():
	# TODO handle time up
	print("time up!")
