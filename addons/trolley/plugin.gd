@tool
extends EditorPlugin

var trolley_debug_panel_scene = preload("res://addons/trolley/TrolleyDebugPanel.tscn")
var trolley_debug_panel
var editor_interface


func _enter_tree():
	Debug.prn("<Trolley>")
	add_autoload_singleton("Trolley", "res://addons/trolley/Trolley.gd")

	trolley_debug_panel = trolley_debug_panel_scene.instantiate()

	editor_interface = get_editor_interface()
	trolley_debug_panel.editor_interface = editor_interface
	editor_interface.get_editor_main_screen().add_child(trolley_debug_panel)

	_make_visible(false)


func _exit_tree():
	# remove_autoload_singleton("Trolley")

	if trolley_debug_panel:
		trolley_debug_panel.free()
	Debug.prn("</Trolley>")


func _has_main_screen():
	return true

func _make_visible(visible):
	if trolley_debug_panel:
		trolley_debug_panel.visible = visible


func _get_plugin_name():
	return "Trolley"
