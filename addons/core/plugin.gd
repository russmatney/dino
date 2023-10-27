@tool
extends EditorPlugin

var reload_scene_btn = Button.new()
# var reload_games_btn = Button.new()
var container = 0
var editor_interface


func _enter_tree():
	add_autoload_singleton("Util", "res://addons/core/Util.gd")
	add_autoload_singleton("Debug", "res://addons/core/Debug.gd")

	print("<Core>")

	editor_interface = get_editor_interface()

	reload_scene_btn.pressed.connect(reload_scene)
	reload_scene_btn.text = "Reload Scene"
	add_control_to_container(container, reload_scene_btn)

	# reload_games_btn.pressed.connect(reload_games)
	# reload_games_btn.text = "Reload Games"
	# add_control_to_container(container, reload_games_btn)


func _exit_tree():
	print("</Core>")
	remove_autoload_singleton("Util")
	remove_autoload_singleton("Debug")


func reload_scene():
	Debug.pr("-------------------------------------------------")
	Debug.pr("[ReloadScene] ", Time.get_time_string_from_system())
	var edited_scene = editor_interface.get_edited_scene_root()
	Debug.pr("edited scene", edited_scene, ".scene_file_path", edited_scene.scene_file_path)
	editor_interface.reload_scene_from_path(edited_scene.scene_file_path)
	Debug.pr("-------------------------------------------------")

# func reload_games():
# 	Debug.pr("not impled!")
