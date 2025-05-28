@tool
class_name ActionHint
extends Node2D

@onready var label: RichTextLabel = $Label
@onready var icon: ActionInputIcon = $ActionInputIcon

@export var label_text := "" :
	set(t):
		label_text = t
		update_text()

@export var action_name := "" :
	set(t):
		action_name = t
		update_text()

func update_text() -> void:
	if label:
		label.text = "[center][jump]" + label_text
	if icon and action_name:
		icon.set_icon_for_action(action_name)

func display(k_or_a: String, label_t: String) -> void:
	action_name = k_or_a
	label_text = label_t
	update_text()
	set_visible(true)

# TODO follow up with previous use of hide() here
func hide_action_hint() -> void:
	set_visible(false)

func _ready() -> void:
	update_text()

