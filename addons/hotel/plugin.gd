@tool
extends EditorPlugin


func _enter_tree():
	Debug.prn("<HOTEL>")

	# TODO add Hotel tab and db viewer


func _exit_tree():
	Debug.prn("</HOTEL>")
