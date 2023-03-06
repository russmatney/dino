@tool
extends Control


func _ready():
	Debug.prn("oh so ready.")

var editor_interface

func _on_reload_plugin_button_pressed():
	Debug.prn("reloading hotel plugin")

	editor_interface.set_plugin_enabled("hotel", false)
	editor_interface.set_plugin_enabled("hotel", true)
