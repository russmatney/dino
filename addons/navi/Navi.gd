extends Node
# expects to be autoloaded

var current_scene = null

var last_scene_stack = []

# overwritable, but defaults to a reasonable pause screen
export(PackedScene) var pause_menu_scene = preload("res://addons/navi/NaviPauseMenu.tscn")
var pause_container
var pause_menu

# overwritable, but defaults to a reasonable death screen
export(PackedScene) var death_menu_scene = preload("res://addons/navi/NaviDeathMenu.tscn")
var death_container
var death_menu

# overwritable, but defaults to a reasonable win screen
export(PackedScene) var win_menu_scene = preload("res://addons/navi/NaviWinMenu.tscn")
var win_container
var win_menu

func pp(msg):
	print("[Navi] ", msg)

## ready ###################################################################


func _ready():
	var f = File.new()
	if not f.file_exists(main_menu_path):
		pp(str("No scene at path: ", main_menu_path, ", nav_to_main_menu will no-op."))

	pause_mode = PAUSE_MODE_PROCESS

	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

	# should one day be conditional/opt-out
	pause_container = CanvasLayer.new()
	pause_menu = pause_menu_scene.instance()
	pause_container.add_child(pause_menu)
	call_deferred("add_child", pause_container)

	# should one day be conditional/opt-out
	death_container = CanvasLayer.new()
	death_menu = death_menu_scene.instance()
	death_container.add_child(death_menu)
	call_deferred("add_child", death_container)

	# should one day be conditional/opt-out
	win_container = CanvasLayer.new()
	win_menu = win_menu_scene.instance()
	win_container.add_child(win_menu)
	call_deferred("add_child", win_container)

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

	# b/c you can pause the game and go to main instead of clicking go to main
	death_menu.hide()


func _deferred_goto_scene(path_or_packed_scene):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s
	if path_or_packed_scene is String:
		s = ResourceLoader.load(path_or_packed_scene)
	else:
		s = path_or_packed_scene

	# Instance the new scene.
	current_scene = s.instance()
	print("[Navi] Current scene: ", current_scene)
	print("[Navi] last scene stack: ", last_scene_stack)

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)

#####################################################################
# add child

# helper for adding a child to the current scene
func add_child(child, legible_unique_name = false):
	current_scene.call_deferred("add_child", child, legible_unique_name)

#####################################################################
# main menu

var main_menu_path = "res://src/menus/DinoMenu.tscn"

func set_main_menu(path):
	var f = File.new()
	if f.file_exists(path):
		pp(str("Updating main_menu_path: ", path))
		main_menu_path = path
	else:
		pp(str("No scene at path: ", main_menu_path, ", can't set main menu."))

func nav_to_main_menu():
	var f = File.new()
	if f.file_exists(main_menu_path):
		nav_to(main_menu_path)
	else:
		pp(str("No scene at path: ", main_menu_path, ", can't navigate."))

## pause ###################################################################

var pause_menu_path = "res://addons/navi/NaviPauseMenu.tscn"

func set_pause_menu(path):
	var f = File.new()
	if f.file_exists(path):
		pp(str("Updating pause_menu_path: ", path))
		pause_menu_path = path

		pause_menu.queue_free()
		pause_menu = load(pause_menu_path).instance()
		pause_container.add_child(pause_menu)
	else:
		pp(str("No scene at path: ", path, ", can't set pause menu."))

func _unhandled_input(event):
	# Navi implying Trolly dep
	if Trolley.is_pause(event):
		Navi.toggle_pause()


func toggle_pause():
	var t = get_tree()
	if t.paused:
		resume()
	else:
		pause()


func pause():
	var t = get_tree()
	t.paused = true
	if pause_menu:
		pause_menu.show()
	# Navi implying DJ dep
	print("dj.resume")
	DJ.resume_menu_song()


func resume():
	var t = get_tree()
	t.paused = false
	if pause_menu:
		pause_menu.hide()
	# Navi implying DJ dep
	print("dj.pause")
	DJ.pause_menu_song()


## death ###########################################

func show_death_menu():
	death_menu.show()

func hide_death_menu():
	death_menu.hide()


## win ###########################################

func show_win_menu():
	win_menu.show()

func hide_win_menu():
	win_menu.hide()
