extends Node2D

@onready var label = $Label
@onready var key = $Key

func display(key_text, label_text):
	set_visible(true)
	key.text = "[center][jump]" + key_text
	label.text = "[center][jump]" + label_text

func hide():
	set_visible(false)
