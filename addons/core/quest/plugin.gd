@tool
extends EditorPlugin


func _enter_tree():
	Log.pr("<QUEST>")


func _exit_tree():
	Log.pr("</QUEST>")
