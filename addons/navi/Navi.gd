@tool
extends Node

# https://docs.godotengine.org/en/latest/tutorials/io/background_loading.html#doc-background-loading

# TODO logger abstraction
func pp(msg, msg2=null, msg3=null, msg4=null, msg5=null):
	if msg5:
		print("[Navi] ", msg, msg2, msg3, msg4, msg5)
	if msg4:
		print("[Navi] ", msg, msg2, msg3, msg4)
	if msg3:
		print("[Navi] ", msg, msg2, msg3)
	if msg2:
		print("[Navi] ", msg, msg2)
	else:
		print("[Navi] ", msg)

func add_menu(scene):
	var menu = scene.instantiate()
	menu.hide()
	call_deferred("add_child", menu)
	return menu

## ready ###################################################################

var current_scene
var last_scene_stack = []

func _ready():
	if not FileAccess.file_exists(main_menu_path):
		pp("No scene at path: ", main_menu_path, ", nav_to_main_menu will no-op.")

	process_mode = PROCESS_MODE_ALWAYS
	print("proc mode: ", process_mode)

	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

	pause_menu = add_menu(pause_menu_scene)
	death_menu = add_menu(death_menu_scene)
	win_menu = add_menu(win_menu_scene)

	if "node_path" in current_scene:
		last_scene_stack.push_back(current_scene.node_path)
	print("[Navi] Current scene: ", current_scene)


## nav_to ###################################################################


func nav_to(path_or_packed_scene):
	print("[Navi] nav_to: ", path_or_packed_scene)
	# NOTE this scene stack grows forever!
	last_scene_stack.push_back(path_or_packed_scene)
	call_deferred("_deferred_goto_scene", path_or_packed_scene)
	# Navi implying DJ dep
	# TODO opt-in/out of pausing the music
	DJ.pause_menu_song()

	if death_menu and is_instance_valid(death_menu):
		# b/c you can pause the game and go to main instead of clicking go to main
		death_menu.hide()


signal new_scene_instanced(inst)


func _deferred_goto_scene(path_or_packed_scene):
	# It is now safe to remove_at the current scene
	current_scene.free()

	# Load the new scene.
	var s
	if path_or_packed_scene is String:
		s = ResourceLoader.load(path_or_packed_scene)
	else:
		s = path_or_packed_scene

	# Instance the new scene.
	pp("Instancing new scene: ", s)
	current_scene = s.instantiate()
	pp("Current scene: ", current_scene)
	emit_signal("new_scene_instanced", current_scene)

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().set_current_scene(current_scene)


#####################################################################
# add child


# helper for adding a child to the current scene
func add_child_to_current(child):
	# could use the scene_tree's current_scene directly
	current_scene.call_deferred("add_child", child)


#####################################################################
# main menu

var main_menu_path = "res://src/menus/DinoMenu.tscn"


func set_main_menu(path):
	if FileAccess.file_exists(path):
		pp("Updating main_menu_path: ", path)
		main_menu_path = path
	else:
		pp("No scene at path: ", main_menu_path, ", can't set main menu.")


func nav_to_main_menu():
	if FileAccess.file_exists(main_menu_path):
		death_menu.hide()
		win_menu.hide()
		nav_to(main_menu_path)
		resume()
	else:
		pp("No scene at path: ", main_menu_path, ", can't navigate.")


## pause ###################################################################

@export var pause_menu_scene: PackedScene = preload("res://addons/navi/NaviPauseMenu.tscn")
var pause_menu

func set_pause_menu(path):
	if FileAccess.file_exists(path):
		pp("Updating pause_menu: ", path)
		if pause_menu:
			pause_menu.queue_free()
		pause_menu = add_menu(load(path))
	else:
		pp("No scene at path: ", path, ", can't set pause menu.")


func _unhandled_input(event):
	# Navi implying Trolly dep
	if Trolley.is_pause(event):
		Navi.toggle_pause()


func toggle_pause():
	var t = get_tree()
	print("toggle pause invoked. paused?: ", t.paused)
	print("proc mode: ", process_mode)
	if t.paused:
		resume()
	else:
		pause()


func pause():
	pp("pausing")
	var t = get_tree()
	t.paused = true
	if pause_menu and is_instance_valid(pause_menu):
		pause_menu.show()
	# Navi implying DJ dep
	print("dj.resume")
	DJ.pause_game_song()
	DJ.resume_menu_song()


func resume():
	pp("unpausing")
	var t = get_tree()
	t.paused = false
	if pause_menu and is_instance_valid(pause_menu):
		pause_menu.hide()
	# Navi implying DJ dep
	print("dj.pause")
	DJ.pause_menu_song()
	DJ.resume_game_song()


## death ###########################################

@export var death_menu_scene: PackedScene = preload("res://addons/navi/NaviDeathMenu.tscn")
var death_menu

func set_death_menu(path):
	if FileAccess.file_exists(path):
		pp("Updating death_menu: ", path)
		if death_menu:
			death_menu.queue_free()
		death_menu = add_menu(load(path))
	else:
		pp("No scene at path: ", path, ", can't set death menu.")


func show_death_menu():
	pp("Show death screen")
	DJ.pause_game_song()
	death_menu.show()


func hide_death_menu():
	pp("Hide death screen")
	death_menu.hide()


## win ###########################################

@export var win_menu_scene: PackedScene = preload("res://addons/navi/NaviWinMenu.tscn")
var win_menu

func set_win_menu(path):
	if FileAccess.file_exists(path):
		pp("Updating win_menu: ", path)
		if win_menu:
			win_menu.queue_free()
		win_menu = add_menu(load(path))
	else:
		pp("No scene at path: ", path, ", can't set win menu.")

func show_win_menu():
	pp("Show win screen")
	DJ.pause_game_song()
	win_menu.show()


func hide_win_menu():
	pp("Hide win screen")
	win_menu.hide()
