tool
extends EditorPlugin

# A class member to hold the dock during the plugin life cycle.
var dock


func _enter_tree():
	print("demo-dock entering tree")
	# Initialization of the plugin goes here.
	# Load the dock scene and instance it.
	dock = preload("res://addons/demo_dock/my_dock.tscn").instance()

	# Add the loaded scene to the docks.
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)


# Note that LEFT_UL means the left of the editor, upper-left dock.


func _exit_tree():
	print("demo-dock exiting tree")
	# Clean-up of the plugin goes here.
	# Remove the dock.
	remove_control_from_docks(dock)
	# Erase the control from the memory.
	dock.free()
