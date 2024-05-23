@tool
class_name ActionHint
extends Node2D

@onready var label = $Label
@onready var icon = $ActionInputIcon

@export var label_text: String = "" :
	set(t):
		label_text = t
		update_text()

@export var action_name: String = "" :
	set(t):
		action_name = t
		update_text()

func update_text():
	if label:
		label.text = "[center][jump]" + label_text
	if icon and action_name:
		icon.set_icon_for_action(action_name)

func display(k_or_a, label_t):
	action_name = k_or_a
	label_text = label_t
	update_text()
	set_visible(true)

func hide():
	set_visible(false)

func _ready():
	update_text()

