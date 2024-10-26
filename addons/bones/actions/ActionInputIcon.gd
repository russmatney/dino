@tool
extends TextureRect
class_name ActionInputIcon

@export var input_text = "" :
	set(v):
		input_text = v
		render_icon()

# @export var action_name_ = "" :
# 	set(v):
# 		action_name_ = v
# 		set_icon_for_action(v)

@export var joy_button = [] :
	set(v):
		if v and len(v) == 2:
			input_text = button_to_input_text(v)

func button_to_input_text(button):
	var device_type = button[0]
	var idx = button[1]
	if device_type == "keyboard":
		# not sure i love this
		device_type = "generic"

	var dev_map = device_button_idx_input_text.get(device_type, {})
	var txt
	if idx in dev_map:
		txt = dev_map.get(idx, "")

	return txt


@export var joy_axis = [] :
	set(v):
		if input_text == "" and v and len(v) == 2:
			input_text = axis_to_input_text(v)

func axis_to_input_text(axis):
	var idx = axis[0]
	var val = axis[1]

	var txt = ""
	match idx:
		JOY_AXIS_LEFT_X:
			if val > 0:
				txt = "Joystick right"
			else:
				txt = "Joystick left"
		JOY_AXIS_LEFT_Y:
			if val > 0:
				txt = "Joystick down"
			else:
				txt = "Joystick up"
		JOY_AXIS_RIGHT_X:
			if val > 0:
				txt = "Joystick right"
			else:
				txt = "Joystick left"
		JOY_AXIS_RIGHT_Y:
			if val > 0:
				txt = "Joystick down"
			else:
				txt = "Joystick up"
		JOY_AXIS_TRIGGER_LEFT:
			txt = "Left Trigger"
		JOY_AXIS_TRIGGER_RIGHT:
			txt = "Right Trigger"
		JOY_AXIS_INVALID, JOY_AXIS_SDL_MAX, JOY_AXIS_MAX:
			Log.warn("Unsupported joystick axis", axis)
			return
	return txt

## public

func set_icon_for_action(action_name, device=null):
	if Engine.is_editor_hint():
		input_text = U.rand_of(["A Button", "Enter", "X", "Ctrl+Z"])
		return
	if not device:
		device = InputHelper.device
	var input = InputHelper.get_keyboard_or_joypad_input_for_action(action_name)
	if device == InputHelper.DEVICE_KEYBOARD:
		input_text = OS.get_keycode_string(input.get_keycode_with_modifiers())
	elif "button_index" in input:
		# TODO support axes as well
		joy_button = [device, input.button_index]
	elif "axis" in input:
		joy_axis = [input.axis, input.axis_value]
	else:
		Log.warn("Unexpected input:", action_name, input)

## ready

func _ready():
	render_icon()

func get_input_texture(input_key):
	var inp_texture = keymap.get(input_key)

	if inp_texture:
		return inp_texture
	else:
		Log.warn("No texture found for input", input_key)
		return

func render_icon():
	if input_text == null or input_text in ignores:
		set_visible(false)
		return
	set_visible(true)

	var input_key = ""
	var mods = []
	var parts = input_text.split("+")
	if len(parts) == 0:
		set_visible(false)
		return
	parts.reverse()
	input_key = parts[0]
	if len(parts) > 1:
		mods = parts.slice(1)

	var inp_texture = get_input_texture(input_key)
	if inp_texture == null:
		return
	# var mod_width = 0

	var mod_textures = []
	for m in mods:
		var mod_texture = get_input_texture(m)
		mod_textures.append(mod_texture)
		# if m in ["Shift"]:
		# 	mod_width += 90
		# elif m in ["Ctrl"]:
		# 	mod_width += 80
		# else:
		# 	mod_width += 80

	if len(mod_textures) > 0:
		Log.pr("I have mod_textures to render!")

	# update text
	set_texture(inp_texture)

	# update size
	# if input_text in ["Space"]:
	# 	set_custom_minimum_size(Vector2(110 + mod_width, 0))
	# elif input_text in ["Enter"]:
	# 	set_custom_minimum_size(Vector2(90 + mod_width, 0))
	# elif input_text in ["Escape"]:
	# 	set_custom_minimum_size(Vector2(70 + mod_width, 0))
	# else:
	# 	set_custom_minimum_size(Vector2(50 + mod_width, 0))

var ignores = ["", "Kp Enter"]

var keymap = {
	# keyboard
	"A"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_a.png"),
	"B"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_b.png"),
	"C"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_c.png"),
	"D"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_d.png"),
	"E"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_e.png"),
	"F"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_f.png"),
	"G"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_g.png"),
	"H"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_h.png"),
	"I"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_i.png"),
	"J"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_j.png"),
	"K"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_k.png"),
	"L"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_l.png"),
	"M"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_m.png"),
	"N"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_n.png"),
	"O"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_o.png"),
	"P"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_p.png"),
	"Q"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_q.png"),
	"R"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_r.png"),
	"S"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_s.png"),
	"T"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_t.png"),
	"U"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_u.png"),
	"V"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_v.png"),
	"W"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_w.png"),
	"X"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_x.png"),
	"Y"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_y.png"),
	"Z"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_z.png"),
	"0"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_0.png"),
	"1"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_1.png"),
	"2"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_2.png"),
	"3"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_3.png"),
	"4"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_4.png"),
	"5"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_5.png"),
	"6"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_6.png"),
	"7"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_7.png"),
	"8"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_8.png"),
	"9"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_9.png"),
	"!"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_exclamation.png"),
	"\""=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_quote.png"),
	# "#"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_pound.png"),
	# "$"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_dollar.png"),
	# "%"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_percent.png"),
	# "&"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_ampersand.png"),
	"'"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_apostrophe.png"),
	# "("=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_parens_open.png"),
	# ")"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_parens_closed).png"),
	"*"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_asterisk.png"),
	"+"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_plus.png"),
	","=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_comma.png"),
	"-"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_minus.png"),
	"."=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_period.png"),
	"/"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_slash_forward.png"),
	":"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_colon.png"),
	";"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_semicolon.png"),
	"<"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_bracket_less.png"),
	# "="=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_equal.png"),
	">"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_bracket_greater.png"),
	"?"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_question.png"),
	"["=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_bracket_open.png"),
	"]"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_bracket_close.png"),
	"\\"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_slash_back.png"),
	"^"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_caret.png"),
	# "_"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_underscore.png"),
	# "`"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_tick.png"),
	# "{"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_curly_brace_open.png"),
	# "}"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_curly_brace_closed.png"),
	# "|"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_pipe.png"),
	"~"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_tilde.png"),
	# "@"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_at.png"),

	"Ctrl"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_ctrl.png"),
	# "Scroll Lock"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_ctrl.png"),
	"Escape"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_escape.png"),
	"Alt"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_alt.png"),
	"Tab"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/key_tab.png"),
	# "Menu"="M",
	"Super"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/key_command.png"),
	"Backspace"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_backspace.png"),
	"Enter"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_enter.png"),
	"Shift"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_shift.png"),
	"Print Screen"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_printscreen.png"),
	"End"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_end.png"),
	"Delete"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_delete.png"),
	"Insert"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_insert.png"),
	"Home"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_home.png"),
	"Caps Lock"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_capslock.png"),
	"Page Up"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_page_up.png"),
	"Page Down"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_page_down.png"),
	"Up"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_arrows_up.png"),
	"Down"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_arrows_down.png"),
	"Left"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_arrows_left.png"),
	"Right"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_arrows_right.png"),
	"Space"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_space.png"),
	# extras
	"f1"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_f1.png"),
	"f2"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_f2.png"),
	"f3"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_f3.png"),
	"f4"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_f4.png"),
	"f5"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_f5.png"),
	"f6"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_f6.png"),
	"f7"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_f7.png"),
	"f8"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_f8.png"),
	"f9"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_f9.png"),
	"f10"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_f10.png"),
	"f11"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_f11.png"),
	"f12"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/keyboard_f12.png"),
	# mouse
	"Mouse"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/mouse.png"),
	"Mouse Left Click"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/mouse_left.png"),
	"Mouse Right Click"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/mouse_right.png"),
	"Mouse Scroll"=preload("res://assets/kenney-input-prompts/Keyboard & Mouse/Default/mouse_scroll.png"),
	# controller buttons
	"A Button"=preload("res://assets/kenney-input-prompts/Nintendo Switch/Default/switch_button_a.png"),
	"B Button"=preload("res://assets/kenney-input-prompts/Nintendo Switch/Default/switch_button_b.png"),
	"X Button"=preload("res://assets/kenney-input-prompts/Nintendo Switch/Default/switch_button_x.png"),
	"Y Button"=preload("res://assets/kenney-input-prompts/Nintendo Switch/Default/switch_button_y.png"),
	"Cross Button"=preload("res://assets/kenney-input-prompts/PlayStation 5/Default/playstation_button_cross.png"),
	"Square Button"=preload("res://assets/kenney-input-prompts/PlayStation 5/Default/playstation_button_square.png"),
	"Triangle Button"=preload("res://assets/kenney-input-prompts/PlayStation 5/Default/playstation_button_triangle.png"),
	"Circle Button"=preload("res://assets/kenney-input-prompts/PlayStation 5/Default/playstation_button_circle.png"),
	# controller start/pause/select/home/share/whatever
	"Steamdeck Options"=preload("res://assets/kenney-input-prompts/Steam Deck/Default/steamdeck_button_options.png"),
	"Steamdeck View"=preload("res://assets/kenney-input-prompts/Steam Deck/Default/steamdeck_button_view.png"),
	"Steamdeck Home"=preload("res://assets/kenney-input-prompts/Steam Deck/Default/steamdeck_button_quickaccess.png"),
	"Xbox Share"=preload("res://assets/kenney-input-prompts/Xbox Series/Default/xbox_button_share.png"),
	"Xbox Menu"=preload("res://assets/kenney-input-prompts/Xbox Series/Default/xbox_button_menu.png"),
	"Switch Plus"=preload("res://assets/kenney-input-prompts/Nintendo Switch/Default/switch_button_plus.png"),
	"Switch Minus"=preload("res://assets/kenney-input-prompts/Nintendo Switch/Default/switch_button_minus.png"),
	"Switch Home"=preload("res://assets/kenney-input-prompts/Nintendo Switch/Default/switch_button_home.png"),
	"Playstation Options"=preload("res://assets/kenney-input-prompts/PlayStation 4/Default/playstation_button_options.png"),
	"Playstation Share"=preload("res://assets/kenney-input-prompts/PlayStation 4/Default/playstation_button_share.png"),
	# controller directional
	"Dpad"=preload("res://assets/kenney-input-prompts/Nintendo Switch/Default/switch_dpad.png"),
	"Dpad up"=preload("res://assets/kenney-input-prompts/Nintendo Switch/Default/switch_dpad_up.png"),
	"Dpad down"=preload("res://assets/kenney-input-prompts/Nintendo Switch/Default/switch_dpad_down.png"),
	"Dpad left"=preload("res://assets/kenney-input-prompts/Nintendo Switch/Default/switch_dpad_left.png"),
	"Dpad right"=preload("res://assets/kenney-input-prompts/Nintendo Switch/Default/switch_dpad_right.png"),
	# controller shoulder buttons
	"Left Button"=preload("res://assets/kenney-input-prompts/Steam Deck/Default/steamdeck_button_l1.png"),
	"Right Button"=preload("res://assets/kenney-input-prompts/Steam Deck/Default/steamdeck_button_r1.png"),
	"Left Trigger"=preload("res://assets/kenney-input-prompts/Steam Deck/Default/steamdeck_button_l2.png"),
	"Right Trigger"=preload("res://assets/kenney-input-prompts/Steam Deck/Default/steamdeck_button_r2.png"),
	# arcade stick
	# "Arcade stick up left"="q",
	# "Arcade stick up"="w",
	# "Arcade stick up right"="e",
	# "Arcade stick left"="a",
	# "Arcade stick neutral"="s",
	# "Arcade stick right"="d",
	# "Arcade stick down left"="z",
	# "Arcade stick down"="x",
	# "Arcade stick down right"="c",
	# "Arcade stick 'L'"="[",
	# "Arcade stick 'R'"="]",
	# joystick
	# "Joystick up left"="r",
	"Joystick up"=preload("res://assets/kenney-input-prompts/Generic/Default/generic_stick_up.png"),
	# "Joystick up right"="y",
	"Joystick left"=preload("res://assets/kenney-input-prompts/Generic/Default/generic_stick_left.png"),
	"Joystick neutral"=preload("res://assets/kenney-input-prompts/Generic/Default/generic_stick.png"),
	"Joystick right"=preload("res://assets/kenney-input-prompts/Generic/Default/generic_stick_right.png"),
	# "Joystick down left"="v",
	"Joystick down"=preload("res://assets/kenney-input-prompts/Generic/Default/generic_stick_down.png"),
	# "Joystick down right"="n",
	"Joystick 'L'"=preload("res://assets/kenney-input-prompts/Nintendo Switch/Default/switch_stick_side_l.png"),
	"Joystick 'R'"=preload("res://assets/kenney-input-prompts/Nintendo Switch/Default/switch_stick_side_r.png"),
	}

var device_button_idx_input_text = {
		"xbox"={
			0: "A Button",
			1: "B Button",
			2: "X Button",
			3: "Y Button",
			4: "Xbox Share", # back
			5: "Home",
			6: "Xbox Menu", # menu
			7: "Left Stick",
			8: "Right Stick",
			9: "Left Button",
			10: "Right Button",
			11: "Dpad up",
			12: "Dpad down",
			13: "Dpad left",
			14: "Dpad right",
			15: "Share",
			},
		"switch"={
			0: "B Button",
			1: "A Button",
			2: "Y Button",
			3: "X Button",
			4: "Switch Minus", # -
			5: "Switch Home",
			6: "Switch Plus", # +
			7: "Left Stick",
			8: "Right Stick",
			9: "Left Button",
			10: "Right Button",
			11: "Dpad up",
			12: "Dpad down",
			13: "Dpad left",
			14: "Dpad right",
			15: "Capture",
			},
		"switch_left_joycon"={},
		"switch_right_joycon"={},
		"playstation"={
			0: "Cross Button",
			1: "Circle Button",
			2: "Square Button",
			3: "Triangle Button",
			4: "Playstation Share", # Select
			5: "PS",
			6: "Playstation Options", # Start
			7: "Left Stick",
			8: "Right Stick",
			9: "Left Button",
			10: "Right Button",
			11: "Dpad up",
			12: "Dpad down",
			13: "Dpad left",
			14: "Dpad right",
			15: "Microphone",
			20: "Touchpad",
			},
		"generic"={
			0: "A Button",
			1: "B Button",
			2: "X Button",
			3: "Y Button",
			4: "Steamdeck View", # back
			5: "Steamdeck Home",
			6: "Steamdeck Options", # menu
			7: "Left Stick",
			8: "Right Stick",
			9: "Left Button",
			10: "Right Button",
			11: "Dpad up",
			12: "Dpad down",
			13: "Dpad left",
			14: "Dpad right",
			15: "Share",
			},
	}
