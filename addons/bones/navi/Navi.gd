@tool
extends Node

## vars ###################################################################

var first_scene: Node
var current_scene: Node

## ready ###################################################################

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS

	var root := get_tree().get_root()
	var first := root.get_child(root.get_child_count() - 1)
	var main_scene_path: String = ProjectSettings.get_setting("application/run/main_scene")
	if first.scene_file_path == main_scene_path:
		first_scene = first
## input ###################################################################

func _unhandled_input(event: InputEvent) -> void:
	if not Engine.is_editor_hint() and Trolls.is_pause(event):
		Navi.toggle_pause()

## process ###################################################################

var focused_node: Node
var attempted_focus_for_scene: Node
func _process(_delta: float) -> void:
	# PERF could only run this when in a menu/control/ui screen
	var new_focused_node := get_viewport().gui_get_focus_owner()
	if new_focused_node == null and attempted_focus_for_scene != current_scene:
		find_focus()
	elif new_focused_node != focused_node:
		focused_node = new_focused_node
		_on_focus_changed(focused_node as Control)

## focus changes ###################################################################

func _on_focus_changed(control: Control) -> void:
	if control == null:
		find_focus()

# this might compete with grab_focus, should only be called if there is nothing in focus
func find_focus(scene: Node = null) -> void:
	if scene == null:
		scene = current_scene
	if scene == null:
		return
	attempted_focus_for_scene = scene
	if scene.has_method("set_focus"):
		@warning_ignore("unsafe_method_access")
		scene.set_focus()
	else:
		# there are things besides buttons to focus on...
		var btns := scene.find_children("*", "BaseButton", true, false)
		btns = btns.filter(func(b): return not b.is_disabled())
		if len(btns) > 0:
			for btn: Node in btns:
				if btn is Control:
					(btn as Control).grab_focus()
					break

## nav_to ###################################################################

# Supports a path, packed_scene, or instance of a scene
func nav_to(scene: Variant, opts:={}) -> void:
	Log.info("nav_to: ", scene, opts)
	hide_menus()
	_deferred_goto_scene.call_deferred(scene, opts)
	# ensure unpaused
	resume()

func _deferred_goto_scene(scene: Variant, opts:={}) -> void:
	get_tree().current_scene.queue_free()

	var next_scene: Node
	if scene is String:
		var scene_str: String = scene
		var s: PackedScene = ResourceLoader.load(scene_str)
		if s == null:
			Log.warn("Cannot instantiate passed scene, failed to load", scene)
			return
		next_scene = s.instantiate()
	elif scene is PackedScene:
		var sc_packed: PackedScene = scene
		next_scene = sc_packed.instantiate()
	else:
		# assuming it is already instantiated
		next_scene = scene

	if "setup" in opts:
		if opts.setup != null:
			@warning_ignore("unsafe_method_access")
			opts.setup.call(next_scene)

	if "on_ready" in opts:
		next_scene.ready.connect(func() -> void:
			@warning_ignore("unsafe_method_access")
			opts.on_ready.call(next_scene))

	# default to waiting for the current_scene to be freed
	if not opts.get("skip_await"):
		if get_tree().current_scene:
			await get_tree().current_scene.tree_exited

	# for navi's tracking
	current_scene = next_scene
	# Add it as a child of root
	get_tree().get_root().add_child(current_scene)
	# compatibility with SceneTree.change_scene_to_file()
	get_tree().set_current_scene(current_scene)

	# set the focus for the current scene
	find_focus()

## current_scene_path ###################################################################

func current_scene_path() -> String:
	if current_scene == null:
		var root := get_tree().get_root()
		current_scene = root.get_children()[-1]
		get_tree().set_current_scene(current_scene)
	return current_scene.scene_file_path

## add child ###################################################################

# helper for adding a child to the current scene
func add_child_to_current(child: Node, deferred := true) -> void:
	# could use the scene_tree's current_scene directly
	if current_scene == null:
		var root := get_tree().get_root()
		current_scene = root.get_children()[-1]
		get_tree().set_current_scene(current_scene)

	if deferred:
		current_scene.add_child.call_deferred(child)
	else:
		current_scene.add_child(child)

## pause ###################################################################

signal pause_toggled(paused: bool)

func toggle_pause() -> void:
	if get_tree().paused:
		resume()
	else:
		pause()

func pause() -> void:
	get_tree().paused = true
	if pause_menu and is_instance_valid(pause_menu):
		pause_menu.show()
		find_focus(pause_menu)
	# Music.switch_to_pause_music()
	pause_toggled.emit(true)

func resume() -> void:
	get_tree().paused = false
	hide_menus()
	# Music.switch_to_game_music()
	pause_toggled.emit(false)

func is_paused() -> bool:
	return get_tree().paused


## menus ###################################################################

var menus := []

func add_menu(scene: Variant) -> CanvasLayer:
	if not scene is PackedScene:
		for c in get_children():
			var sfp: String = scene.resource_path
			if c.scene_file_path == sfp:
				@warning_ignore("unsafe_method_access")
				c.hide()
				return c
	else:
		var sc_packed: PackedScene = scene
		var menu: CanvasLayer = sc_packed.instantiate()
		menu.hide()
		menus.append(menu)
		add_child.call_deferred(menu)
		return menu
	return

func hide_menus() -> void:
	menus = menus.filter(func(m: Node) -> bool: return is_instance_valid(m))
	menus.map(func(m: CanvasLayer) -> void: m.hide())

	var other_menus := get_tree().get_nodes_in_group("menus")
	other_menus.map(func(m: CanvasLayer) -> void: m.hide())

	find_focus()

func show_menu(menu: Variant) -> void:
	menus = menus.filter(func(m: Node) -> bool: return is_instance_valid(m))
	if not menu in menus:
		menu = add_menu(menu)

	if menu != null and menu is CanvasLayer:
		var m: CanvasLayer = menu
		m.show()
		find_focus(m)

func clear_menus() -> void:
	menus = menus.filter(func(m: Node) -> bool: return is_instance_valid(m))
	for m: Node in menus:
		m.queue_free()

## main menu ###################################################################

var main_menu_path: String

func set_main_menu(path_or_scene: Variant) -> void:
	var path := U.to_scene_path(path_or_scene)
	if ResourceLoader.exists(path):
		Log.info("Setting main_menu", path.get_file())
		main_menu_path = path
	else:
		Log.warn("No scene at path", path, ", can't set main menu.")

func nav_to_main_menu() -> void:
	if main_menu_path and ResourceLoader.exists(main_menu_path):
		hide_menus()
		nav_to(main_menu_path)
	else:
		Log.warn("No scene at path: ", main_menu_path, ", can't navigate.")

func quit_game() -> void:
	get_tree().quit()

## pause menu ###################################################################

var pause_menu: CanvasLayer

func set_pause_menu(path_or_scene: Variant) -> void:
	if path_or_scene == null:
		Log.warn("Null passed to set_pause_menu, returning")
		return
	var path := U.to_scene_path(path_or_scene)
	if ResourceLoader.exists(path):
		if pause_menu and is_instance_valid(pause_menu):
			if pause_menu.scene_file_path == path:
				return
			# is there a race-case here?
			pause_menu.queue_free()
		Log.info("Setting pause_menu", path.get_file())
		pause_menu = add_menu(load(path))
	else:
		Log.warn("No scene at path", path, ", can't set pause menu.")

## death ###########################################

var death_menu: CanvasLayer

func set_death_menu(path_or_scene: Variant) -> void:
	if path_or_scene == null:
		Log.warn("Null passed to set_death_menu, returning")
		return
	var path := U.to_scene_path(path_or_scene)
	if ResourceLoader.exists(path):
		if death_menu and is_instance_valid(death_menu):
			if death_menu.scene_file_path == path:
				return
			death_menu.queue_free()
		death_menu = add_menu(load(path))
	else:
		Log.warn("No scene at path: ", path, ", can't set death menu.")

func show_death_menu() -> void:
	# Music.pause_game_song()
	death_menu.show()
	find_focus(death_menu)

func hide_death_menu() -> void:
	death_menu.hide()

## win ###########################################

var win_menu: CanvasLayer

func set_win_menu(path_or_scene: Variant) -> void:
	if path_or_scene == null:
		Log.warn("Null passed to set_win_menu, returning")
		return
	var path := U.to_scene_path(path_or_scene)
	if ResourceLoader.exists(path):
		if win_menu and is_instance_valid(win_menu):
			if win_menu.scene_file_path == path:
				return
			win_menu.queue_free()
		win_menu = add_menu(load(path))
	else:
		Log.warn("No scene at path: ", path, ", can't set win menu.")

func show_win_menu() -> void:
	# Music.pause_game_song()
	win_menu.show()
	find_focus(win_menu)

func hide_win_menu() -> void:
	win_menu.hide()
