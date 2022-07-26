tool
extends Control

# TODO handle hard-coding/mis-coding of keys for actions?
# we should pass an action and lookup the key via Trolley instead of setting it raw here
export(String) var action = ""
export(String) var key = ""


func set_label(action):
	get_node("%Label").text = action


var key_icon = preload("res://addons/trolley/TrolleyKeyIcon.tscn")


func add_key(k):
	var icon = key_icon.instance()
	icon.text = k

	var key_list = get_node("%KeyList")
	key_list.add_child(icon)


func _ready():
	if Engine.editor_hint:
		request_ready()

		# var key_list = get_node("%KeyList")
		# for c in key_list.get_children():
		# 	key_list.remove_child(c)

		# add_key("T")
		# add_key("Test")

	if action:
		set_label(action)

	if key:
		var key_list = get_node("%KeyList")
		for c in key_list.get_children():
			key_list.remove_child(c)

		add_key(key)
