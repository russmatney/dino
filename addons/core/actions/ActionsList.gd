@tool
extends VBoxContainer
class_name ActionsList

@export var ignore_prefix: String = "ui_"
@export var only_prefix: String


func _ready():
	if Engine.is_editor_hint():
		request_ready()

	build_actions_list()


var ActionLabel = preload("res://addons/core/actions/ActionLabel.tscn")


func build_actions_list():
	for ch in get_children():
		remove_child(ch)
		ch.queue_free()

	for ac in Trolls.inputs_list({
		ignore_prefix=ignore_prefix, only_prefix=only_prefix}):
		var action_label = ActionLabel.instantiate()
		var action_name = ac["action"].capitalize()
		action_label.set_label(action_name)

		for k in ac["keys"]:
			action_label.add_key(k)

		add_child(action_label)
