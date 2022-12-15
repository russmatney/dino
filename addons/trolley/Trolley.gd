tool
extends Node

var actions


func _ready():
	if Engine.editor_hint:
		request_ready()

	build_actions_dict()


# TODO unit tests
func build_actions_dict():
	# apparently we need to reload this
	InputMap.load_from_globals()

	actions = {}
	for ac in InputMap.get_actions():
		var evts = InputMap.get_action_list(ac)

		var setting = ProjectSettings.get_setting(str("input/", ac))

		var keys = []
		for evt in evts:
			if evt is InputEventKey:
				keys.append(OS.get_scancode_string(evt.scancode))

		actions[ac] = {"events": evts, "setting": setting, "keys": keys, "action": ac}


class ActionsSorter:
	static func sort_alphabetical(a, b):
		if a["action"] <= b["action"]:
			return true
		return false


# TODO write unit tests, use parse_input_event to test controls
# TODO maybe support filtering out actions by prefix
func actions_list(ignore_prefix = "", only_prefix = ""):
	if not actions:
		build_actions_dict()

	var actions_list = actions.values()
	actions_list.sort_custom(ActionsSorter, "sort_alphabetical")

	var axs = []
	for ax in actions_list:
		if ignore_prefix:
			if ax["action"].begins_with(ignore_prefix):
				continue

		if only_prefix:
			if not ax["action"].begins_with(only_prefix):
				continue

		axs.append(ax)

	return axs


##################################################################
# public
##################################################################


# returns a normalized Vector2 based on the controller's movement
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


func is_attack(event):
	return event.is_action_pressed("attack")


func is_action(event):
	return event.is_action_pressed("action")


func is_pause(event):
	return event.is_action_pressed("pause")
