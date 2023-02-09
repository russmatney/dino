@tool
extends EditorPlugin

var reload_scene_btn = Button.new()
var container = 0
var editor_interface


func _enter_tree():
	print("<Core>")
	add_autoload_singleton("Util", "res://addons/core/Util.gd")

	editor_interface = get_editor_interface()
	reload_scene_btn.connect("pressed",Callable(self,"reload_scene"))
	reload_scene_btn.text = "Reload Scene"
	add_control_to_container(container, reload_scene_btn)


func _exit_tree():
	remove_autoload_singleton("Util")
	print("</Core>")


func reload_scene():
	print("\n-----------------")
	print("[ReloadScene] ", Time.get_time_string_from_system())

	var edited_scene = editor_interface.get_edited_scene_root()
	print("edited scene: ", edited_scene, " filename: ", edited_scene.scene_file_path)

	editor_interface.reload_scene_from_path(edited_scene.scene_file_path)

	print("-----------------\n")
