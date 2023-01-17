tool
extends EditorPlugin


var force_reload_btn = Button.new()
var container = 0
var editor_interface


func _enter_tree():
	print("<Core>")
	add_autoload_singleton("Util", "res://addons/core/Util.gd")

	editor_interface = get_editor_interface()
	force_reload_btn.connect("pressed", self, "_on_button_pressed")
	force_reload_btn.text = "Force Reload"
	add_control_to_container(container, force_reload_btn)


func _exit_tree():

	remove_autoload_singleton("Util")
	print("</Core>")


func _on_button_pressed():
	# reopen_scene()
	reload_scene()


func reload_scene():
	print("\n-----------------")
	print("[ForceReloadEditor] reloading scene: ", Time.get_time_string_from_system())

	var edited_scene = editor_interface.get_edited_scene_root()
	print("edited scene: ", edited_scene, " filename: ", edited_scene.filename)

	editor_interface.reload_scene_from_path(edited_scene.filename)

	print("-----------------\n")
