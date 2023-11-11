@tool
extends EditorPlugin


func _enter_tree():
	Log.prn("<Cam>")


func _exit_tree():
	print("</Cam>")
