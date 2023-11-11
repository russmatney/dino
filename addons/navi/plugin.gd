@tool
extends EditorPlugin


func _enter_tree():
	Log.prn("<Navi>")
	add_autoload_singleton("Navi", "res://addons/navi/Navi.gd")


func _exit_tree():
	remove_autoload_singleton("Navi")
	Log.prn("</Navi>")
