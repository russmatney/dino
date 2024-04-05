@tool
extends Node

## input/action dicts ########################################################################

var inputs_by_action_label
var action_labels_by_input


## ready ########################################################################

func _ready():
	if Engine.is_editor_hint():
		request_ready()

	build_inputs_dict()

## build inputs dict ########################################################################

func build_inputs_dict():
	# apparently we need to reload this
	InputMap.load_from_project_settings()

	inputs_by_action_label = {}
	action_labels_by_input = {}
	for ac in InputMap.get_actions():
		var evts = InputMap.action_get_events(ac)

		var setting = ProjectSettings.get_setting(str("input/", ac))

		var keys = []
		var buttons = []
		for evt in evts:
			if evt is InputEventKey:
				var key_str = OS.get_keycode_string(evt.keycode)
				# could support 'Enter, Shift, etc'
				keys.append(key_str)

				if not key_str in action_labels_by_input:
					action_labels_by_input[key_str] = []
				action_labels_by_input[key_str].append(ac)

			elif evt is InputEventJoypadButton:
				var btn_idx = evt.button_index
				buttons.append(btn_idx)

				# hopefully btn_idx doesn't collide with anything
				if not btn_idx in action_labels_by_input:
					action_labels_by_input[btn_idx] = []
				action_labels_by_input[btn_idx].append(ac)

		inputs_by_action_label[ac] = {events=evts, setting=setting, keys=keys, action=ac,
			buttons=buttons}

## inputs list ########################################################################

class InputsSorter:
	static func sort_alphabetical(a, b):
		if "action" in a and "action" in b:
			if a["action"] <= b["action"]:
				return true
		elif "action" in b:
			return true
		return false


func inputs_list(opts={}):
	if inputs_by_action_label == null or len(inputs_by_action_label) == 0:
		build_inputs_dict()

	var ignore_prefix = opts.get("ignore_prefix", "ui_text_")
	var only_prefix = opts.get("only_prefix", "")

	var inputs_list = inputs_by_action_label.values()

	var inps = []
	for inp in inputs_list:
		if ignore_prefix:
			if inp["action"].begins_with(ignore_prefix):
				continue

		if only_prefix:
			if not inp["action"].begins_with(only_prefix):
				continue

		inps.append(inp)

	return inps


func keys_for_input_action(action_label):
	build_inputs_dict()
	if action_label in inputs_by_action_label:
		return inputs_by_action_label[action_label]["keys"]

func _axs_for_input(input):
	var axs = []
	var action_labels = action_labels_by_input[input]
	for ac in action_labels:
		axs.append({
			input=inputs_by_action_label[ac],
			action_label=ac,
			})
	return axs


func actions_for_input(event):
	# Log.prn(action_labels_by_input)
	var axs = []
	if event is InputEventKey:
		var key_str = OS.get_keycode_string(event.keycode)
		if key_str in action_labels_by_input:
			axs.append_array(_axs_for_input(key_str).map(func(ax):
				ax["key_str"] = key_str
				return ax))
	if event is InputEventJoypadButton:
		var btn_idx = event.button_index
		if btn_idx in action_labels_by_input:
			axs.append_array(_axs_for_input(btn_idx).map(func(ax):
				ax["btn_idx"] = btn_idx
				return ax))
	return axs


## simulate ################################################################

func sim_action_pressed(action, release_after=null, released=null):
	var evt = InputEventAction.new()
	evt.action = action
	evt.pressed = true
	Input.parse_input_event(evt)
	if release_after != null:
		await get_tree().create_timer(release_after).timeout
		sim_action_released.call_deferred(action)
		if released != null:
			released.emit()

func sim_action_released(action):
	var evt = InputEventAction.new()
	evt.action = action
	evt.pressed = false
	Input.parse_input_event(evt)

func close():
	sim_action_pressed("close", 0.2)

func attack(t=0.5):
	if t:
		sim_action_pressed("attack", t)
	else:
		sim_action_pressed("attack")

func sim_move(dir: Vector2, release_after=0.8, released=null):
	match dir:
		Vector2.LEFT: sim_action_pressed("move_left", release_after, released)
		Vector2.RIGHT: sim_action_pressed("move_right", release_after, released)
		Vector2.UP: sim_action_pressed("move_up", release_after, released)
		Vector2.DOWN: sim_action_pressed("move_down", release_after, released)
		_: Log.warn("Not-impled: simulated input in non-cardinal directions", dir)

