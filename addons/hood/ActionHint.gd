@tool
class_name ActionHint
extends Node2D

@onready var label = $Label
@onready var key = $Key

@export var label_text: String = "" :
	set(t):
		label_text = t
		update_text()

@export var key_text: String = "" :
	set(t):
		key_text = t
		update_text()

func update_text():
	if label:
		label.text = "[center][jump]" + label_text
	if key:
		var k_text = key_text.to_lower()
		if key_text in key_map:
			k_text = key_map[key_text]

		key.text = "[center][jump]" + k_text

func display(key_t, label_t):
	key_text = key_t
	label_text = label_t
	update_text()
	set_visible(true)

func hide():
	set_visible(false)

func _ready():
	Hood.prn("action hint ready")
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
