@tool
extends EditorPlugin

var TrolleyBottomPanel


func _enter_tree():
	Debug.prn("enter")
	add_autoload_singleton("Trolley", "res://addons/trolley/Trolley.gd")

	TrolleyBottomPanel = preload("res://addons/trolley/TrolleyBottomPanel.tscn").instantiate()
	add_control_to_bottom_panel(TrolleyBottomPanel, "Trolley")


func _exit_tree():
	Debug.prn("exit")
	remove_autoload_singleton("Trolley")

	remove_control_from_bottom_panel(TrolleyBottomPanel)
	TrolleyBottomPanel.free()
