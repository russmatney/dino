tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("Util", "res://addons/core/Util.gd")


func _exit_tree():
	remove_autoload_singleton("Util")
