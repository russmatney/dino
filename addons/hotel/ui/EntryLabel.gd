@tool
extends Control

var initial_selected = false

@onready var entry_name = $EntryName
@onready var select_button = $SelectButton

#######################################################################
# entry setter

var entry :
	set(val):
		entry = val
		set_label()

#######################################################################
# set label

func entry_to_label(e):
	var key = e["key"]
	return key.replace("/", "\t[color=crimson]/[/color]\t")

func set_label():
	if entry_name:
		if entry == null:
			Log.warn("No entry set, cannot set label")
			entry_name.text = ""
			return

		entry_name.text = entry_to_label(entry)

#######################################################################
# button pressed

signal select_toggled(selected: bool)

func _on_select_button_pressed():
	select_toggled.emit(select_button.button_pressed)

func set_selected(selected):
	select_button.set_pressed_no_signal(selected)

#######################################################################
# testing ui

@export var test_entry: bool :
	set(val):
		test_entry = val
		if val:
			var entries = Hotel.query()
			if len(entries) > 0:
				var e = entries[3]
				Log.prn("testing with entry: ", e)
				entry = e
		else:
			entry = null

#######################################################################
# ready

func _ready():
	set_selected(initial_selected)

	set_label()
