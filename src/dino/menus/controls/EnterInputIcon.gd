@tool
extends RichTextLabel

@export var input_text = "" :
	set(v):
		input_text = v
		render_icon()

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
		[JOY_AXIS_INVALID, JOY_AXIS_TRIGGER_LEFT, JOY_AXIS_TRIGGER_RIGHT, JOY_AXIS_SDL_MAX, JOY_AXIS_MAX]:
			Log.pr("Unsupported joystick axis")
			return
	return txt

## public

func set_icon_for_action(action_name, device=null):
	if Engine.is_editor_hint():
		input_text = U.rand_of(["A Button", "Space", "X", "Ctrl+Z"])
		return
	if not device:
		device = InputHelper.device
	var input = InputHelper.get_keyboard_or_joypad_input_for_action(action_name)
	if device == InputHelper.DEVICE_KEYBOARD:
		input_text = OS.get_keycode_string(input.get_keycode_with_modifiers())
	else:
		# TODO support axes as well
		joy_button = [device, input.button_index]

## ready

func _ready():
	render_icon()

func get_literal_text(input_key):
	var ei_key = keymap.get(input_key)
	var ei_key_extra = keymap_extra.get(input_key)

	if ei_key:
		return ei_key
	elif ei_key_extra:
		# our bold font is the enter_input_extra variant
		return "[b]%s[/b]" % ei_key_extra
	else:
		Log.warn("No key found for input", input_key)
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

	var key = get_literal_text(input_key)
	if key == null or key == "":
		return
	var mod_width = 0

	for m in mods:
		var mod_text = get_literal_text(m)
		key = "%s%s" % [mod_text, key]
		if m in ["Shift"]:
			mod_width += 90
		elif m in ["Ctrl"]:
			mod_width += 80
		else:
			mod_width += 80

	text = key

	if input_text in ["Space"]:
		set_custom_minimum_size(Vector2(110 + mod_width, 0))
	elif input_text in ["Enter"]:
		set_custom_minimum_size(Vector2(90 + mod_width, 0))
	elif input_text in ["Escape"]:
		set_custom_minimum_size(Vector2(70 + mod_width, 0))
	else:
		set_custom_minimum_size(Vector2(50 + mod_width, 0))

var ignores = ["", "Kp Enter"]

var keymap = {
	"A"="a",
	"B"="b",
	"C"="c",
	"D"="d",
	"E"="e",
	"F"="f",
	"G"="g",
	"H"="h",
	"I"="i",
	"J"="j",
	"K"="k",
	"L"="l",
	"M"="m",
	"N"="n",
	"O"="o",
	"P"="p",
	"Q"="q",
	"R"="r",
	"S"="s",
	"T"="t",
	"U"="u",
	"V"="v",
	"W"="w",
	"X"="x",
	"Y"="y",
	"Z"="z",
	"0"="0",
	"1"="1",
	"2"="2",
	"3"="3",
	"4"="4",
	"5"="5",
	"6"="6",
	"7"="7",
	"8"="8",
	"9"="9",
	"!"="!",
	"\""="\"",
	"#"="#",
	"$"="$",
	"%"="%",
	"&"="&",
	"'"="'",
	"("="(",
	")"=")",
	"*"="*",
	"+"="+",
	","=",",
	"-"="-",
	"."=".",
	"/"="/",
	":"=":",
	";"=";",
	"<"="<",
	"="="=",
	">"=">",
	"?"="?",
	"["="[",
	"]"="]",
	"\\"="\\",
	"^"="^",
	"_"="_",
	"`"="`",
	"{"="{",
	"}"="}",
	"|"="|",
	"~"="~",
	"@"="@",
	"Ctrl"="C",
	"Scroll Lock"="L",
	"Escape"="R",
	"Alt"="A",
	"Tab"="T",
	"Menu"="M",
	"Super"="W",
	"Backspace"="B",
	"Enter"="E",
	"Shift"="S",
	"Print Screen"="P",
	"End"="N",
	"Delete"="D",
	"Insert"="I",
	"Home"="H",
	"Caps Lock"="O",
	"Pause"="U",
	"Page Up"="K",
	"Page Down"="J",
	"Up"="G",
	"Down"="F",
	"Left"="V",
	"Right"="Q",
	"Space"="Z",
	}


var keymap_extra={
	"f1"="1",
	"f2"="2",
	"f3"="3",
	"f4"="4",
	"f5"="5",
	"f6"="6",
	"f7"="7",
	"f8"="8",
	"f9"="9",
	"f10"="0",
	"f11"="(",
	"f12"=")",
	"Mouse"="M",
	"Mouse Left Click"="L",
	"Mouse Right Click"="R",
	"Mouse Scroll"="S",
	"A Button"="A",
	"B Button"="B",
	"X Button"="X",
	"Y Button"="Y",
	"Cross Button"="X", # mapped to X button for now
	"Square Button"="N",
	"Triangle Button"="T",
	"Circle Button"="C",
	"Dpad"="D",
	"Dpad up"="^",
	"Dpad down"="V",
	"Dpad left"="<",
	"Dpad right"=">",
	"Left Button"="Q",
	"Right Button"="W",
	"Left Trigger"="O",
	"Right Trigger"="P",
	"Arcade stick up left"="q",
	"Arcade stick up"="w",
	"Arcade stick up right"="e",
	"Arcade stick left"="a",
	"Arcade stick neutral"="s",
	"Arcade stick right"="d",
	"Arcade stick down left"="z",
	"Arcade stick down"="x",
	"Arcade stick down right"="c",
	"Arcade stick 'L'"="[",
	"Arcade stick 'R'"="]",
	"Joystick up left"="r",
	"Joystick up"="t",
	"Joystick up right"="y",
	"Joystick left"="f",
	"Joystick neutral"="g",
	"Joystick right"="h",
	"Joystick down left"="v",
	"Joystick down"="b",
	"Joystick down right"="n",
	"Joystick 'L'"="{",
	"Joystick 'R'"="}",
	}

var device_button_idx_input_text = {
		"xbox"={
			0: "A Button",
			1: "B Button",
			2: "X Button",
			3: "Y Button",
			4: "Pause", # back
			5: "Home",
			6: "Menu", # menu
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
			4: "Menu", # -
			5: "",
			6: "Pause", # +
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
			4: "Menu", # Select
			5: "PS",
			6: "Pause", # Start
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
			4: "Pause", # back
			5: "Home",
			6: "Menu", # menu
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
