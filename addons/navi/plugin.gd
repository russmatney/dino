@tool
extends EditorPlugin


func _enter_tree():
	Hood.prn("enter")
	add_autoload_singleton("Navi", "res://addons/navi/Navi.gd")


func _exit_tree():
	Hood.prn("exit")
	remove_autoload_singleton("Navi")
