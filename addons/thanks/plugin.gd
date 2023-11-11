@tool
extends EditorPlugin


func _enter_tree():
	Log.pr("<THANKS>")


func _exit_tree():
	Log.pr("</Thanks>")
