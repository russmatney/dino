@tool
extends EditorPlugin


func _enter_tree():
	print("<KINK>")
	add_autoload_singleton("Kink", "res://addons/kink/Kink.gd")


func _exit_tree():
	print("</KINK>")
	remove_autoload_singleton("Kink")
