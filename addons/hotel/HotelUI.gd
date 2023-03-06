@tool
extends Control

#######################################################################
# ready

func _ready():
	list_entries()

#######################################################################
# reload button

var editor_interface
func _on_reload_plugin_button_pressed():
	Debug.prn(&"Reloading hotel plugin ----------------------------------")
	editor_interface.set_plugin_enabled("hotel", false)
	editor_interface.set_plugin_enabled("hotel", true)
	Debug.prn(&"Reloaded hotel plugin -----------------------------------")

	# TODO refocus hotel main screen plugin

#######################################################################
# db entries list

@onready var db_entries = $%DBEntries
const entry_label_scene = preload("res://addons/hotel/EntryLabel.tscn")

func list_entries():
	var entries = Hotel.query()
	for e in entries:
		var lbl = entry_label_scene.instantiate()
		lbl.entry = e
		lbl.select_toggled.connect(toggle_entry_details.bind(e))
		db_entries.call_deferred("add_child", lbl)

#######################################################################
# db detail entries list

@onready var db_entry_details = $%DBEntryDetails
const entry_detail_scene = preload("res://addons/hotel/EntryDetail.tscn")

var selected_entries = []

func toggle_entry_details(_selected, entry):
	if entry in selected_entries:
		selected_entries.erase(entry)
		for ch in db_entry_details.get_children():
			if ch.entry == entry:
				ch.queue_free()
	else:
		selected_entries.append(entry)
		var detail = entry_detail_scene.instantiate()
		detail.entry = entry
		db_entry_details.call_deferred("add_child", detail)
