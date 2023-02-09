@tool
extends EditorPlugin


func _enter_tree():
	print("<Camera3D>")


func _exit_tree():
	print("</Camera3D>")
