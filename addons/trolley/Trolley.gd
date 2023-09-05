@tool
extends Node

## is this window focused?
# https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html#window-focus
var focused := true

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			focused = false
		NOTIFICATION_APPLICATION_FOCUS_IN:
			focused = true


## input/action dicts ########################################################################

var inputs_by_action_label
var action_labels_by_input


## ready ########################################################################

func _ready():
	if Engine.is_editor_hint():
		request_ready()

	build_inputs_dict()

################################################
# input

func _unhandled_input(event):
	if not Engine.is_editor_hint():
		if is_debug_toggle(event):
			Debug.toggle_debug()
		elif is_event(event, "slowmo"):
			slowmo_start()
		elif is_event_released(event, "slowmo"):
			slowmo_stop()

################################################
# slowmo toggle

func slowmo_start():
	Hood.notif("Slooooooow mooooootion")
	Cam.start_slowmo("debug_overlay_slowmo", 0.3)

func slowmo_stop():
	Hood.notif("Back to full speed")
	Cam.stop_slowmo("debug_overlay_slowmo")



## build inputs dict ########################################################################

# TODO unit tests
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
				# TODO support 'Enter, Shift, etc'
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


# TODO write unit tests, use parse_input_event to test controls
# TODO maybe support filtering out inputs by prefix
func inputs_list(opts={}):
	if inputs_by_action_label == null or len(inputs_by_action_label) == 0:
		build_inputs_dict()

	var ignore_prefix = opts.get("ignore_prefix", "ui_text_")
	var only_prefix = opts.get("only_prefix", "")

	var inputs_list = inputs_by_action_label.values()
	# TODO this prints bad-comparision function error?
	# inputs_list.sort_custom(Callable(InputsSorter, "sort_alphabetical"))

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
	# TODO no need to rebuild in prod... or at all?
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
	# Debug.prn(action_labels_by_input)
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


##################################################################
# public
##################################################################


# returns a normalized Vector2 based checked the controller's movement
func move_vector():
	if focused:
		return Input.get_vector("move_left", "move_right", "move_up", "move_down")
	return Vector2.ZERO

func is_move(event):
	return is_event(event, "move_left") or is_event(event, "move_right") or \
		is_event(event, "move_up") or is_event(event, "move_down")

func is_event(event, event_name):
	if focused:
		return event.is_action_pressed(event_name)
	return false

func is_pressed(event, event_name):
	return is_event(event, event_name)

func is_held(event, event_name):
	return is_event(event, event_name)

func is_event_released(event, event_name):
	if focused:
		return event.is_action_released(event_name)
	return false

func is_fire(event):
	return is_event(event, "fire")

func is_fire_released(event):
	return is_event_released(event, "fire")

func is_jump(event):
	return is_event(event, "jump")

func is_dash(event):
	return is_event(event, "dash")

func is_jetpack(event):
	return is_event(event, "jetpack")

func is_attack(event):
	return is_event(event, "attack")

func is_attack_released(event):
	return is_event_released(event, "attack")

func is_action(event):
	return is_event(event, "action")

func is_cycle_next_action(event):
	return is_event(event, "cycle_next_action")

func is_cycle_prev_action(event):
	return is_event(event, "cycle_previous_action")

func is_pause(event):
	return is_event(event, "pause")

func is_close(event):
	return is_event(event, "close")

func is_debug_toggle(event):
	return is_event(event, "debug_toggle")
