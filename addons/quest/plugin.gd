@tool
extends EditorPlugin


func _enter_tree():
	Debug.pr("<QUEST>")


func _exit_tree():
	Debug.pr("</QUEST>")
