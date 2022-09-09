tool
extends EditorPlugin


func _enter_tree():
	print("dj entering tree")
	add_autoload_singleton("DJ", "res://addons/dj/DJ.gd")


func _exit_tree():
	print("dj exiting tree")
	remove_autoload_singleton("DJ")
