@tool
extends VBoxContainer
class_name ActionsList

@export var ignore_prefix: String = "ui_"
@export var only_prefix: String


func _ready() -> void:
	if Engine.is_editor_hint():
		request_ready()

	build_actions_list()


var action_label_scene := preload("res://addons/bones/actions/ActionLabel.tscn")


func build_actions_list() -> void:
	for ch in get_children():
		remove_child(ch)
		ch.queue_free()

	for ac: Dictionary in Trolls.inputs_list({
		ignore_prefix=ignore_prefix, only_prefix=only_prefix}):
		var action_label: ActionLabel = action_label_scene.instantiate()
		@warning_ignore("unsafe_method_access")
		var action_name: String = ac["action"].capitalize()
		action_label.set_label(action_name)

		for k: String in ac["keys"]:
			action_label.add_key(k)

		add_child(action_label)
