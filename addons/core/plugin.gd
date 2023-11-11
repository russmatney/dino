@tool
extends EditorPlugin

var reload_scene_btn = Button.new()
var editor_interface


func _enter_tree():
	Log.pr("<Core>")
	add_autoload_singleton("Debug", "res://addons/core/Debug.gd")

	editor_interface = get_editor_interface()

	reload_scene_btn.pressed.connect(reload_scene)
	reload_scene_btn.text = "R"
	add_control_to_container(CONTAINER_TOOLBAR, reload_scene_btn)
	reload_scene_btn.get_parent().move_child(reload_scene_btn, 0)


func _exit_tree():
	remove_autoload_singleton("Debug")
	remove_control_from_container(CONTAINER_TOOLBAR, reload_scene_btn)
	Log.pr("</Core>")


func reload_scene():
	Log.pr("-------------------------------------------------")
	Log.pr("[ReloadScene] ", Time.get_time_string_from_system())
	var edited_scene = editor_interface.get_edited_scene_root()
	Log.pr("edited scene", edited_scene, ".scene_file_path", edited_scene.scene_file_path)
	editor_interface.reload_scene_from_path(edited_scene.scene_file_path)
	Log.pr("-------------------------------------------------")
