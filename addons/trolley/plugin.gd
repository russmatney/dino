@tool
extends EditorPlugin

var TrolleyBottomPanel


func _enter_tree():
	Hood.prn("enter")
	add_autoload_singleton("Trolley", "res://addons/trolley/Trolley.gd")

	TrolleyBottomPanel = preload("res://addons/trolley/TrolleyBottomPanel.tscn").instantiate()
	add_control_to_bottom_panel(TrolleyBottomPanel, "Trolley")


func _exit_tree():
	Hood.prn("exit")
	remove_autoload_singleton("Trolley")

	remove_control_from_bottom_panel(TrolleyBottomPanel)
	TrolleyBottomPanel.free()
