@tool
extends Control

#######################################################################
# reload button

var editor_interface
func _on_reload_plugin_button_pressed():
	if Engine.is_editor_hint():
		Debug.pr(&"Reloading dj plugin ----------------------------------")
		editor_interface.set_plugin_enabled("dj", false)
		editor_interface.set_plugin_enabled("dj", true)
		editor_interface.set_main_screen_editor("DJTurnTable")
		Debug.pr(&"Reloaded dj plugin -----------------------------------")
	else:
		Debug.pr("DJ UI Reload Not impled outside of editor")
