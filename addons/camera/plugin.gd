@tool
extends EditorPlugin


func _enter_tree():
	Hood.prn("<Cam>")


func _exit_tree():
	Hood.prn("</Cam>")
