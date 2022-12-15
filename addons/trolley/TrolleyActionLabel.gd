tool
extends Control


func set_label(text):
	get_node("%Label").text = text

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
