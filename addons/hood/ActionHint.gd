@tool
class_name ActionHint
extends Node2D

@onready var label = $Label
@onready var key = $Key

@export var label_text: String = "" :
	set(t):
		label_text = t
		update_text()

@export var key_or_action: String = "" :
	set(t):
		key_or_action = t
		update_text()

func update_text():
	if label:
		label.text = "[center][jump]" + label_text
	if key:
		# attempts to find a matching input action with keys for the passed "input_action"
		# otherwise, the "keys" are used as the key_or_action directly
		var keys = Trolley.keys_for_input_action(key_or_action)
		var k_text
		if keys != null and len(keys) > 0:
			k_text = "".join(keys)
		else:
			k_text = key_or_action

		k_text = k_text.to_lower()
		if k_text in key_map:
			k_text = key_map[k_text]

		key.text = "[center][jump]" + k_text

func display(k_or_a, label_t):
	key_or_action = k_or_a
	label_text = label_t
	update_text()
	set_visible(true)

func hide():
	set_visible(false)

func _ready():
	update_text()


var key_map = {
	"Ctrl": "C",
	"Scroll Lock": "L",
	"Esc": "R",
	"Alt": "A",
	"Tab": "T",
	"Menu": "M",
	"Windows / Super Key": "W",
	"Backspace": "B",
	"Enter": "E",
	"Shift": "S",
	"Print Screen": "P",
	"End": "N",
	"Delete": "D",
	"Insert": "I",
	"Home": "H",
	"Caps Lock": "O",
	"Pause": "U",
	"Page Up": "K",
	"Page Down": "J",
	"Up Arrow": "G",
	"Down Arrow": "F",
	"Left Arrow": "V",
	"Right Arrow": "Q",
	"Space Bar": "Z",
	}
