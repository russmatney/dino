@tool
extends VBoxContainer

#######################################################################
# setter

var entry :
	set(val):
		entry = val
		setup()

func entry_to_label(e):
	var key = e["key"]
	return key.replace("/", "\t[color=crimson]/[/color]\t")

#######################################################################
# ready

signal deselected

func _ready():
	setup()
	deselect.pressed.connect(func(): deselected.emit())


@onready var entry_name = $%EntryName
@onready var deselect = $%Deselect
@onready var data = $%EntryData

func setup():
	if entry and entry_name and data:
		entry_name.text = entry_to_label(entry)
		data.text = Log.to_printable([entry], {newlines=true})

#######################################################################
# testing ui

@export var test_entry: bool :
	set(val):
		test_entry = val
		if val:
			var entries = Hotel.query()
			if len(entries) > 0:
				var e = entries[3]
				Log.info("testing with entry: ", e)
				entry = e
		else:
			entry = null
