extends HBoxContainer

var scene_path_control := LineEdit.new()
var file_browser_button := Button.new()
var run_button := Button.new()
var clear_button := Button.new()
var open_root_dir_button := Button.new()
var pin_button := Button.new()
var scene_path: String : set=set_scene_path, get=get_scene_path
var more_button := Button.new()
var split_container := HBoxContainer.new()
var separator := VSeparator.new()

signal scene_path_changed(text)
signal file_browser_requested
signal open_root_dir_pressed
signal pin_button_toggled
signal run_button_pressed

var _full_scene_path

func _init() -> void:
	scene_path_control.custom_minimum_size = Vector2(100, 20)
	pin_button.toggle_mode = true

	split_container.add_child(scene_path_control)
	split_container.add_child(clear_button)

	add_child(split_container)

	more_button.toggle_mode = true
	more_button.size_flags_vertical = SIZE_EXPAND_FILL
	more_button.toggled.connect(split_container.set_visible)
	split_container.visible = more_button.button_pressed

	add_child(more_button)
	add_child(pin_button)
	add_child(run_button)
	add_child(separator)

	scene_path_control.text_changed.connect(_on_scene_path_text_changed)
	file_browser_button.pressed.connect(func(): file_browser_requested.emit())
	open_root_dir_button.pressed.connect(func(): open_root_dir_pressed.emit())
	clear_button.pressed.connect(_on_clear_button_pressed)
	pin_button.toggled.connect(_on_pin_button_toggled)
	run_button.pressed.connect(func(): run_button_pressed.emit())

func _on_scene_path_text_changed(new_text: String):
	var updated_path = "%s.tscn" % _full_scene_path.get_base_dir().path_join(new_text)
	scene_path_changed.emit(updated_path)

func _on_clear_button_pressed():
	scene_path_control.text = ""
	_full_scene_path = ""
	_on_scene_path_text_changed("")


func _on_pin_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		if len(editor_scene_history) > 0:
			var fp = editor_scene_history[0]
			scene_path = fp
			_on_scene_path_text_changed(fp.get_file().get_basename())

	pin_button_toggled.emit(button_pressed)


func set_scene_path(new_path: String) -> void:
	_full_scene_path = new_path
	scene_path_control.text = new_path.get_file().get_basename()


func get_scene_path() -> String:
	return _full_scene_path


var editor_scene_history = []
func editor_scene_changed(scene):
	var path = scene.scene_file_path
	if path in editor_scene_history:
		editor_scene_history.erase(path)
	editor_scene_history.push_front(scene.scene_file_path)
	if len(editor_scene_history) > 5:
		editor_scene_history = editor_scene_history.slice(0, 5)
