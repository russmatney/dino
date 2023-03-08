@tool
extends Node

var inputs


func _ready():
	if Engine.is_editor_hint():
		request_ready()

	build_inputs_dict()


# TODO unit tests
func build_inputs_dict():
	# apparently we need to reload this
	InputMap.load_from_project_settings()

	inputs = {}
	for ac in InputMap.get_actions():
		var evts = InputMap.action_get_events(ac)

		var setting = ProjectSettings.get_setting(str("input/", ac))

		var keys = []
		for evt in evts:
			if evt is InputEventKey:
				# TODO support 'Enter, Shift, etc'
				keys.append(OS.get_keycode_string(evt.keycode))

		inputs[ac] = {"events": evts, "setting": setting, "keys": keys, "action": ac}


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
func inputs_list(ignore_prefix = "", only_prefix = ""):
	if inputs == null or len(inputs) == 0:
		build_inputs_dict()

	var inputs_list = inputs.values()
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


func keys_for_input_action(action):
	# TODO no need to rebuild in prod... or at all?
	build_inputs_dict()
	if action in inputs:
		return inputs[action]["keys"]

##################################################################
# public
##################################################################


# returns a normalized Vector2 based checked the controller's movement
func move_dir():
	var v_diff = Vector2()

	if Input.is_action_pressed("move_right"):
		v_diff.x += 1
	if Input.is_action_pressed("move_left"):
		v_diff.x -= 1
	if Input.is_action_pressed("move_down"):
		v_diff.y += 1
	if Input.is_action_pressed("move_up"):
		v_diff.y -= 1

	return v_diff.normalized()


func is_event(event, event_name):
	return event.is_action_pressed(event_name)

func is_pressed(event, event_name):
	return event.is_action_pressed(event_name)

func is_held(event, event_name):
	return event.is_action_pressed(event_name)

func is_event_released(event, event_name):
	return event.is_action_released(event_name)

func is_jump(event):
	return event.is_action_pressed("jump")

func is_attack(event):
	return event.is_action_pressed("attack")

func is_action(event):
	return event.is_action_pressed("action")

func is_pause(event):
	return event.is_action_pressed("pause")

func is_close(event):
	return event.is_action_pressed("close")

func is_debug_toggle(event):
	return event.is_action_pressed("debug_toggle")
