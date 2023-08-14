@tool
extends EditorPlugin


func _enter_tree():
	Debug.prn("<Cam>")


func _exit_tree():
	print("</Cam>")
