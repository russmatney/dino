@tool
extends VBoxContainer

@onready var entry_name = $EntryName
@onready var data = $EntryData

var entry :
	set(val):
		entry = val
		Debug.prn("Entry Detail set", val)
		setup()

func _ready():
	setup()


func setup():
	if entry and entry_name and data:
		entry_name.text = "[center]%s[/center]" % [entry["key"]]
		data.text = Debug.to_pretty(entry)
