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
	key = key.replace("/", "\t[color=crimson]/[/color]\t")
	return "[center]%s[/center]" % [key]

#######################################################################
# ready

func _ready():
	setup()


@onready var entry_name = $EntryName
@onready var data = $EntryData

func setup():
	if entry and entry_name and data:
		entry_name.text = entry_to_label(entry)
		data.text = Debug.to_pretty(entry, true)

#######################################################################
# testing ui

@export var test_entry: bool :
	set(val):
		test_entry = val
		if val:
			var entries = Hotel.query()
			if len(entries) > 0:
				var e = entries[3]
				Debug.prn("testing with entry: ", e)
				entry = e
		else:
			entry = null
