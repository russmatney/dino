@tool
extends EditorPlugin

const HotelUI = preload("res://addons/hotel/ui/HotelUI.tscn")

var hotel_ui
var editor_interface

func _enter_tree():
	Log.pr("<HOTEL>")

	# hotel_ui = HotelUI.instantiate()
	# editor_interface = get_editor_interface()
	# hotel_ui.editor_interface = editor_interface

	# editor_interface.get_editor_main_screen().add_child(hotel_ui)

	# hide at initial load
	_make_visible(false)


func _exit_tree():
	Log.pr("</HOTEL>")

	if hotel_ui:
		hotel_ui.free()


# func _has_main_screen():
# 	return true


func _make_visible(visible):
	if hotel_ui:
		hotel_ui.visible = visible


func _get_plugin_name():
	return "HotelDB"


# func _get_plugin_icon():
# 	return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
