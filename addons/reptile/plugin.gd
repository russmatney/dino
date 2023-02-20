@tool
extends EditorPlugin


func _enter_tree():
	Hood.prn("<REPTILE>")


func _exit_tree():
	Hood.prn("</REPTILE>")
