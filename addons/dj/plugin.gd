tool
extends EditorPlugin


func _enter_tree():
	print("<DJ>")
	add_autoload_singleton("DJ", "res://addons/dj/DJ.gd")


func _exit_tree():
	remove_autoload_singleton("DJ")
	print("</DJ>")
