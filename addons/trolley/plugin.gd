tool
extends EditorPlugin

var TrolleyBottomPanel

func _enter_tree():
	print("<TROLLEY>")
	add_autoload_singleton("Trolley", "res://addons/trolley/Trolley.gd")

	TrolleyBottomPanel = preload("res://addons/trolley/TrolleyBottomPanel.tscn").instance()
	add_control_to_bottom_panel(TrolleyBottomPanel, "Trolley")



func _exit_tree():
	print("</TROLLEY>")
	remove_autoload_singleton("Trolley")

	remove_control_from_bottom_panel(TrolleyBottomPanel)
	TrolleyBottomPanel.free()
