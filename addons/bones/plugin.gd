@tool
extends EditorPlugin

var reload_scene_btn = Button.new()
var play_metsys_room_btn = Button.new()
var editor_interface

func _enter_tree():
	add_autoload_singleton("Debug", "res://addons/bones/Debug.gd")
	add_autoload_singleton("Navi", "res://addons/bones/navi/Navi.gd")
	add_autoload_singleton("Juice", "res://addons/bones/Juice.gd")
	add_autoload_singleton("DJ", "res://addons/bones/DJ.gd")

	editor_interface = get_editor_interface()

	reload_scene_btn.pressed.connect(reload_scene)
	reload_scene_btn.text = "R"
	add_control_to_container(CONTAINER_TOOLBAR, reload_scene_btn)
	reload_scene_btn.get_parent().move_child(reload_scene_btn, reload_scene_btn.get_index() - 2)

	# TODO abstract out of bones - maybe each game has an addons/editor/plugin.gd or addons/<game-name>/plugin.gd
	play_metsys_room_btn.pressed.connect(play_metsys_room)
	play_metsys_room_btn.text = "M"
	add_control_to_container(CONTAINER_TOOLBAR, play_metsys_room_btn)
	play_metsys_room_btn.get_parent().move_child(play_metsys_room_btn, play_metsys_room_btn.get_index() - 2)


func _exit_tree():
	# remove_autoload_singleton("Navi")
	# remove_autoload_singleton("Debug")
	remove_control_from_container(CONTAINER_TOOLBAR, reload_scene_btn)


func reload_scene():
	print("-------------------------------------------------")
	Log.info("[ReloadScene] ", Time.get_time_string_from_system())
	var edited_scene = editor_interface.get_edited_scene_root()
	Log.info("edited scene", edited_scene, ".scene_file_path", edited_scene.scene_file_path)
	editor_interface.reload_scene_from_path(edited_scene.scene_file_path)
	print("-------------------------------------------------")


func play_metsys_room():
	print("-------------------------------------------------")
	Log.info("[PlayMetSysRoom] ", Time.get_time_string_from_system())
	var edited_scene = editor_interface.get_edited_scene_root()
	Log.info("playing metsys room", edited_scene, ".scene_file_path", edited_scene.scene_file_path)

	OS.set_environment("__metsys_first_room__", edited_scene.scene_file_path)

	# instead of playing this scene, play MetSysGame with this scene as the firstRoom
	# TODO get from MetSys settings!
	var metsys_game_path = "res://src/games/hatbot/HatBotGame.tscn"
	editor_interface.play_custom_scene(metsys_game_path)
	OS.set_environment("__metsys_first_room__", "")
	print("-------------------------------------------------")
