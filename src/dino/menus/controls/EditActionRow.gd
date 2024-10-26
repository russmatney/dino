@tool
extends PanelContainer

## vars ###############################################3

@export var action_name = "ui_accept"

@onready var action_name_label = $%ActionName
@onready var action_inputs = $%ActionInputs

@onready var edit_button = $%EditButton

var input_icon_scene = preload("res://addons/bones/actions/ActionInputIcon.tscn")

var waiting_for_new_input = false
var current_key_input
var current_joy_input

signal edit_pressed()

## ready ###############################################3

func _ready():
	action_name_label.text = "[center]%s[/center]" % action_name.trim_prefix("ui_").capitalize()
	render_action_icons()
	edit_button.pressed.connect(on_edit_pressed)

	if not Engine.is_editor_hint():
		InputHelper.device_changed.connect(func(_d, _i): render_action_icons())

## grab_focus ###############################################3

func set_focus():
	edit_button.grab_focus()

## render action icons ###############################################3

func render_action_icons():
	U.remove_children(action_inputs)

	var icon = input_icon_scene.instantiate()
	icon.set_icon_for_action(action_name)
	action_inputs.add_child(icon)

	# show all option
	# var keyboard_inputs = InputHelper.get_keyboard_inputs_for_action(action_name)
	# var joypad_inputs = InputHelper.get_joypad_inputs_for_action(action_name)

	# for inp in keyboard_inputs:
	# 	if not current_key_input:
	# 		current_key_input = inp
	# 	var icon = input_icon_scene.instantiate()
	# 	var key_str_mods = OS.get_keycode_string(inp.get_keycode_with_modifiers())
	# 	icon.input_text = key_str_mods
	# 	action_inputs.add_child(icon)

	# for inp in joypad_inputs:
	# 	var icon = input_icon_scene.instantiate()
	# 	if "axis" in inp:
	# 		icon.joy_axis = [inp.axis, inp.axis_value]
	# 	else:
	# 		if not current_joy_input:
	# 			current_joy_input = inp
	# 		icon.joy_button = [InputHelper.guess_device_name(), inp.button_index]

	# 	action_inputs.add_child(icon)

## edit signals ###############################################3

func on_edit_pressed():
	waiting_for_new_input = true
	edit_button.text = "...."
	edit_pressed.emit()

func clear_editing_unless(source_button):
	if source_button != self:
		accept_new_control()

## listening for new key ###############################################3

# NOTE not using '_unhandled_input' here b/c we need to grab everything
func _input(event) -> void:
	if not waiting_for_new_input: return

	var accepted = false
	if event is InputEventKey and event.is_pressed():
		accept_event()
		InputHelper.replace_keyboard_input_for_action(action_name, current_key_input, event, true)
		accepted = true

	if event is InputEventJoypadButton and event.is_pressed():
		accept_event()
		InputHelper.replace_joypad_input_for_action(action_name, current_joy_input, event, true)
		accepted = true

	if event is InputEventJoypadMotion and event.axis_value > 0.99:
		if not event.axis in [JOY_AXIS_TRIGGER_LEFT, JOY_AXIS_TRIGGER_RIGHT]:
			return
		accept_event()
		InputHelper.replace_joypad_input_for_action(action_name, current_joy_input, event, true)
		accepted = true

	if accepted:
		accept_new_control()

func accept_new_control():
	render_action_icons()
	edit_button.text = "Edit"
	waiting_for_new_input = false
