tool
extends VBoxContainer

export(String) var ignore_prefix = "ui_"
export(String) var only_prefix


func _ready():
	if Engine.editor_hint:
		request_ready()

	build_actions_list()


var ActionLabel = preload("res://addons/trolley/TrolleyActionLabel.tscn")


func build_actions_list():
	for ch in get_children():
		remove_child(ch)

	for ac in Trolley.actions_list(ignore_prefix, only_prefix):
		var action_label = ActionLabel.instance()
		var action_name = ac["action"].capitalize()
		action_label.set_label(action_name)

		for k in ac["keys"]:
			action_label.add_key(k)

		add_child(action_label)
