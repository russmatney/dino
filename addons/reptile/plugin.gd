@tool
extends EditorPlugin


func _enter_tree():
	Debug.prn("<REPTILE>")


func _exit_tree():
	Debug.prn("</REPTILE>")
