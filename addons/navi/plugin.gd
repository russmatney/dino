@tool
extends EditorPlugin


func _enter_tree():
	Debug.prn("<Navi>")
	add_autoload_singleton("Navi", "res://addons/navi/Navi.gd")


func _exit_tree():
	remove_autoload_singleton("Navi")
	Debug.prn("</Navi>")
