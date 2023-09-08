@tool
extends DotHopLevel

var obj_scene_override = {
	"Player": preload("res://src/dotHop/themes/dots/Player.tscn"),
	"Dot": preload("res://src/dotHop/themes/dots/Dot.tscn"),
	"Dotted": preload("res://src/dotHop/themes/dots/Dot.tscn"),
	"Goal": preload("res://src/dotHop/themes/dots/Dot.tscn"),
	}

func _init():
	obj_scene = obj_scene_override
