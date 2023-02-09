@tool
extends EditorPlugin


func _enter_tree():
	# Initialization of the plugin goes here.
	# Add the new type with a name, a parent type, a script and an icon.
	add_custom_type("MaxSizeContainer", "MarginContainer", preload("max_size_container.gd"), preload("icon.png"))


func _exit_tree():
	# Clean-up of the plugin goes here.
	# Always remember to remove_at it from the engine when deactivated.
	remove_custom_type("MaxSizeContainer")
