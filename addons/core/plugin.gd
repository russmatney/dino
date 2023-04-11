@tool
extends EditorPlugin

var reload_scene_btn = Button.new()
var container = 0
var editor_interface


func _enter_tree():
	Debug.prn("<Core>")
	add_autoload_singleton("Util", "res://addons/core/Util.gd")
	add_autoload_singleton("Debug", "res://addons/core/Debug.gd")

	editor_interface = get_editor_interface()
	reload_scene_btn.pressed.connect(reload_scene)
	reload_scene_btn.text = "Reload Scene"
	add_control_to_container(container, reload_scene_btn)


func _exit_tree():
	remove_autoload_singleton("Util")
	remove_autoload_singleton("Debug")
	Debug.prn("</Core>")


func reload_scene():
	Debug.pr("-------------------------------------------------")
	Debug.pr("[ReloadScene] ", Time.get_time_string_from_system())
	var edited_scene = editor_interface.get_edited_scene_root()
	Debug.pr("edited scene", edited_scene, ".scene_file_path", edited_scene.scene_file_path)
	editor_interface.reload_scene_from_path(edited_scene.scene_file_path)
	Debug.pr("-------------------------------------------------")
