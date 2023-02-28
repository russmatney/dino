@tool
extends EditorPlugin


func _enter_tree():
	Debug.prn("<HOTEL>")


func _exit_tree():
	Debug.prn("</HOTEL>")
