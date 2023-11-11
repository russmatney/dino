@tool
extends EditorPlugin


func _enter_tree():
	Log.prn("<REPTILE>")


func _exit_tree():
	Log.prn("</REPTILE>")
