@tool
extends Control


func _ready():
	if Engine.is_editor_hint():
		request_ready()


#######################################################################
# reload button

var editor_interface
func _on_reload_plugin_button_pressed():
	if Engine.is_editor_hint():
		Debug.pr(&"Reloading trolley plugin ----------------------------------")
		editor_interface.set_plugin_enabled("trolley", false)
		editor_interface.set_plugin_enabled("trolley", true)
		editor_interface.set_main_screen_editor("Trolley")
		Debug.pr(&"Reloaded trolley plugin -----------------------------------")
	else:
		Debug.pr("Trolley UI Reload Not impled outside of editor")
