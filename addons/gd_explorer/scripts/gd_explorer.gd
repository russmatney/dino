@tool
extends EditorPlugin

const main_panel = preload("res://addons/gd_explorer/explorer.tscn")

var main_panel_instance : Control

func _input(event: InputEvent) -> void:
	if main_panel_instance.visible:
		main_panel_instance._input(event)

func _enter_tree():
	main_panel_instance = main_panel.instantiate()
	# Add the main panel to the editor's main viewport.
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	# Hide the main panel. Very much required.
	_make_visible(false)


func _exit_tree():
	if main_panel_instance:
		main_panel_instance.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible


func _get_plugin_name():
	return "GDExplorer"


func _get_plugin_icon():
	# Must return some kind of Texture for the icon.
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
