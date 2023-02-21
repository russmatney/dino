@tool
extends Node2D

@onready var label = $Label
@onready var key = $Key

@export var label_text: String = "" :
	set(t):
		if t:
			label_text = t
			update_text()

@export var key_text: String = "" :
	set(t):
		if t:
			key_text = t
			update_text()

func update_text():
	if label:
		label.text = "[center][jump]" + label_text
	if key:
		key.text = "[center][jump]" + key_text

func display(key_t, label_t):
	key_text = key_t
	label_text = label_t
	update_text()
	set_visible(true)

func hide():
	set_visible(false)

func _ready():
	Hood.prn("action hint ready", inst_to_dict(self))
	update_text()
