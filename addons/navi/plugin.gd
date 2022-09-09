tool
extends EditorPlugin


func _enter_tree():
	print("navi entering tree")
	add_autoload_singleton("Navi", "res://addons/navi/Navi.gd")

func _exit_tree():
	print("navi leaving tree")
	remove_autoload_singleton("Navi")
