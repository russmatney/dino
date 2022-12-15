tool
extends Control

func _ready():
	if Engine.editor_hint:
		request_ready()

		preload("res://addons/trolley/Trolley.gd")

	print(self.name, " _ready() with preload?")

	build_actions_list()

class ActionsSorter:
	static func sort_alphabetical(a, b):
		if a["action"] <= b["action"]:
			return true
		return false

var ActionLabel = preload("res://addons/trolley/TrolleyActionLabel.tscn")

# TODO build and fetch from Trolley autoload
# TODO write unit tests, use parse_input_event to test updated controls
func build_actions_list():
	InputMap.load_from_globals()

	var actions_d = {}
	for ac in InputMap.get_actions():
		var evts = InputMap.get_action_list(ac)

		var setting = ProjectSettings.get_setting(str("input/", ac))

		var keys = []
		for evt in evts:
			if evt is InputEventKey:
				keys.append(OS.get_scancode_string(evt.scancode))

		actions_d[ac] = {
			"events": evts,
			"setting": setting,
			"keys": keys,
			"action": ac
			}

	var actions_list = actions_d.values()

	actions_list.sort_custom(ActionsSorter, "sort_alphabetical")

	for ch in $ActionsList.get_children():
		$ActionsList.remove_child(ch)

	for ac in actions_list:
		var action_label = ActionLabel.instance()
		var action_name = ac["action"]
		action_label.set_label(action_name)

		for k in ac["keys"]:
			action_label.add_key(k)

		$ActionsList.add_child(action_label)
