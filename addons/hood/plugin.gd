@tool
extends EditorPlugin


func _enter_tree():
	Log.prn("<HOOD>")


func _exit_tree():
	Log.prn("</HOOD>")
