@tool
extends Node

# https://docs.godotengine.org/en/latest/tutorials/io/background_loading.html#doc-background-loading

var menus = []

func add_menu(scene):
	for c in get_children():
		var sfp = scene.resource_path
		if c.scene_file_path == sfp:
			c.hide()
			return c

	var menu = scene.instantiate()
	menu.hide()
	menus.append(menu)
	add_child.call_deferred(menu)
	return menu

func hide_menus():
	menus = menus.filter(func(m): return is_instance_valid(m))
	menus.map(func(m): m.hide())
	find_focus()

func show_menu(menu):
	menus = menus.filter(func(m): return is_instance_valid(m))
	if not menu in menus:
		add_menu(menu)
	menu.show()
	find_focus(menu)

## ready ###################################################################

var current_scene
var last_scene_stack = []

func _ready():
	if not ResourceLoader.exists(main_menu_path):
		Debug.prn("No scene at path: ", main_menu_path, ", nav_to_main_menu will no-op.")

	process_mode = PROCESS_MODE_ALWAYS

	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

	pause_menu = add_menu(pause_menu_scene)
	death_menu = add_menu(death_menu_scene)
	win_menu = add_menu(win_menu_scene)

	if "node_path" in current_scene:
		last_scene_stack.push_back(current_scene.node_path)
	Debug.pr("Current scene: ", current_scene)


## process ###################################################################

var focused_node
var attempted_focus_for_scene
func _process(_delta):
	# PERF could only run this when in a menu/control/ui screen
	var new_focused_node = get_viewport().gui_get_focus_owner()
	if new_focused_node == null and attempted_focus_for_scene != current_scene:
		find_focus()
	elif new_focused_node != focused_node:
		focused_node = new_focused_node
		_on_focus_changed(focused_node)


## focus changes ###################################################################

func _on_focus_changed(control: Control) -> void:
	if control == null:
		find_focus()

# this might compete with grab_focus, should only be called if there is nothing in focus
func find_focus(scene=null):
	if scene == null:
		scene = current_scene
	attempted_focus_for_scene = scene
	if scene.has_method("set_focus"):
		scene.set_focus()
	else:
		# TODO likely there are things besides buttons to focus on
		var btns = scene.find_children("*", "BaseButton", true, false)
		if len(btns) > 0:
			btns[0].grab_focus()

## nav_to ###################################################################

# Supports a path, packed_scene, or instance of a scene
func nav_to(scene):
	Debug.prn("nav_to: ", scene)
	# NOTE this scene stack grows forever!
	last_scene_stack.push_back(scene)
	_deferred_goto_scene.call_deferred(scene)

	# TODO pause/resume menus/music fixes
	resume()

	if death_menu and is_instance_valid(death_menu):
		# b/c you can pause the game and go to main instead of clicking go to main
		death_menu.hide()


signal new_scene_instanced(inst)


func _deferred_goto_scene(scene):
	# It is now safe to remove_at the current scene
	current_scene.free()

	Debug.prn("Instancing new scene: ", scene)

	var next_scene
	if scene is String:
		var s = ResourceLoader.load(scene)
		next_scene = s.instantiate()
	elif scene is PackedScene:
		next_scene = scene.instantiate()
	else:
		# assuming it is already instantiated
		next_scene = scene

	current_scene = next_scene
	Debug.prn("New current_scene: ", current_scene)
	new_scene_instanced.emit(current_scene)

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().set_current_scene(current_scene)

	# set the focus for the current scene
	find_focus()


## add child ###################################################################


# helper for adding a child to the current scene
func add_child_to_current(child, deferred=true):
	# could use the scene_tree's current_scene directly
	if deferred:
		current_scene.add_child.call_deferred(child)
	else:
		current_scene.add_child(child)


## main menu ###################################################################

var main_menu_path = "res://src/dino/DinoMenu.tscn"


func set_main_menu(path):
	if ResourceLoader.exists(path):
		Debug.prn("Updating main_menu_path: ", path)
		main_menu_path = path
	else:
		Debug.prn("No scene at path: ", main_menu_path, ", can't set main menu.")


func nav_to_main_menu():
	if ResourceLoader.exists(main_menu_path):
		hide_menus()
		nav_to(main_menu_path)
	else:
		Debug.prn("No scene at path: ", main_menu_path, ", can't navigate.")


## pause ###################################################################

# TODO move to Util
func to_scene_path(path_or_scene):
	var path
	if path_or_scene is String:
		path = path_or_scene
	elif path_or_scene is PackedScene:
		path = path_or_scene.resource_path
	else:
		Debug.warn("Unrecognized type in to_scene_path", path_or_scene)
	return path

@export var pause_menu_scene: PackedScene = preload("res://addons/navi/NaviPauseMenu.tscn")
var pause_menu

func set_pause_menu(path_or_scene):
	if path_or_scene == null:
		Debug.warn("Null passed to set_pause_menu, returning")
		return
	var path = to_scene_path(path_or_scene)
	if ResourceLoader.exists(path):
		if pause_menu:
			if pause_menu.scene_file_path == path:
				return
			# is there a race-case here?
			pause_menu.queue_free()
		pause_menu = add_menu(load(path))
	else:
		Debug.prn("No scene at path: ", path, ", can't set pause menu.")


func _unhandled_input(event):
	if not Engine.is_editor_hint() and Trolley.is_pause(event):
		Navi.toggle_pause()

signal pause_toggled(paused)

func toggle_pause():
	if get_tree().paused:
		resume()
	else:
		pause()


func pause():
	Debug.prn("pausing")
	# TODO don't pause when we're on a menu already

	get_tree().paused = true
	if pause_menu and is_instance_valid(pause_menu):
		pause_menu.show()
		find_focus(pause_menu)
	DJ.pause_game_song()
	DJ.resume_menu_song()
	pause_toggled.emit(true)


func resume():
	Debug.prn("unpausing")
	get_tree().paused = false
	# if pause_menu and is_instance_valid(pause_menu):
	# 	pause_menu.hide()
	# TODO maybe just...
	hide_menus()
	DJ.pause_menu_song()
	DJ.resume_game_song()
	pause_toggled.emit(false)


## death ###########################################

@export var death_menu_scene: PackedScene = preload("res://addons/navi/NaviDeathMenu.tscn")
var death_menu

func set_death_menu(path_or_scene):
	if path_or_scene == null:
		Debug.warn("Null passed to set_pause_menu, returning")
		return
	var path = to_scene_path(path_or_scene)
	if ResourceLoader.exists(path):
		if death_menu:
			if death_menu.scene_file_path == path:
				return
			death_menu.queue_free()
		death_menu = add_menu(load(path))
	else:
		Debug.prn("No scene at path: ", path, ", can't set death menu.")


func show_death_menu():
	Debug.prn("Show death screen")
	DJ.pause_game_song()
	death_menu.show()
	find_focus(death_menu)


func hide_death_menu():
	Debug.prn("Hide death screen")
	death_menu.hide()


## win ###########################################

@export var win_menu_scene: PackedScene = preload("res://addons/navi/NaviWinMenu.tscn")
var win_menu

func set_win_menu(path_or_scene):
	if path_or_scene == null:
		Debug.warn("Null passed to set_pause_menu, returning")
		return
	var path = to_scene_path(path_or_scene)
	if ResourceLoader.exists(path):
		if win_menu:
			if win_menu.scene_file_path == path:
				return
			win_menu.queue_free()
		win_menu = add_menu(load(path))
	else:
		Debug.prn("No scene at path: ", path, ", can't set win menu.")

func show_win_menu():
	Debug.prn("Show win screen")
	DJ.pause_game_song()
	win_menu.show()
	find_focus(win_menu)


func hide_win_menu():
	Debug.prn("Hide win screen")
	win_menu.hide()
