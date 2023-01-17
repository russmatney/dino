tool
extends Node2D

var map_gen

func _ready():
	map_gen = get_node("MapGen")


export(bool) var rebuild setget do_rebuild
func do_rebuild(_v):
	print("Rebuilding. ", Time.get_unix_time_from_system())

	var mg = MapGen.new()
	mg.p_script_vars()
