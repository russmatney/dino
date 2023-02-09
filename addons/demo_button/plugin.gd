@tool
extends EditorPlugin


func _enter_tree():
	print("demo-button entering tree")
	add_custom_type("MyButton", "Button", preload("my_button.gd"), preload("my_button_icon.png"))


func _exit_tree():
	print("demo-button exiting tree")
	# Clean-up of the plugin goes here.
	# Always remember to remove_at it from the engine when deactivated.
	remove_custom_type("MyButton")
