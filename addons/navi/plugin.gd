@tool
extends EditorPlugin


func _enter_tree():
	Debug.prn("enter")
	add_autoload_singleton("Navi", "res://addons/navi/Navi.gd")


func _exit_tree():
	Debug.prn("exit")
	remove_autoload_singleton("Navi")
