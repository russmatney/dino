@tool
extends EditorPlugin

const TurnTable = preload("res://addons/dj/TurnTable.tscn")

var turn_table
var editor_interface

func _enter_tree():
	Debug.prn("<DJ>")
	add_autoload_singleton("DJ", "res://addons/dj/DJ.gd")

	turn_table = TurnTable.instantiate()
	editor_interface = get_editor_interface()
	# Maybe want this to quickly reload the ui, like in hotelUI
	# turn_table.editor_interface = editor_interface

	editor_interface.get_editor_main_screen().add_child(turn_table)

	# hide at initial load
	_make_visible(false)


func _exit_tree():
	remove_autoload_singleton("DJ")
	Debug.prn("</DJ>")


func _has_main_screen():
	return true


func _make_visible(visible):
	if turn_table:
		turn_table.visible = visible


func _get_plugin_name():
	return "DJTurnTable"
