@tool
extends EditorPlugin


func _enter_tree():
	Debug.pr("<THANKS>")


func _exit_tree():
	Debug.pr("</Thanks>")
