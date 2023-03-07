@tool
extends Control

#######################################################################
# ready

func _ready():
	list_entries()
	reset_option_buttons()

	area_option_button.item_selected.connect(_on_area_selected)
	room_option_button.item_selected.connect(_on_room_selected)
	group_option_button.item_selected.connect(_on_group_selected)

	Hotel.entry_updated.connect(_on_entry_update)


#######################################################################
# reload button

var editor_interface
func _on_reload_plugin_button_pressed():
	if Engine.is_editor_hint():
		Debug.prn(&"Reloading hotel plugin ----------------------------------")
		editor_interface.set_plugin_enabled("hotel", false)
		editor_interface.set_plugin_enabled("hotel", true)
		editor_interface.set_main_screen_editor("HotelDB")
		Debug.prn(&"Reloaded hotel plugin -----------------------------------")
	else:
		list_entries()

func _on_rebuild_db_button_pressed():
	Debug.prn(&"Rebuilding hotel db -----------------------------------")
	Hotel.drop_db()
	MvaniaGame.register_areas()
	list_entries()
	Debug.prn(&"Rebuilt hotel db --------------------------------------")

#######################################################################
# option buttons

# consider drying up this pattern

@onready var area_option_button = $%AreaOptionButton
@onready var room_option_button = $%RoomOptionButton
@onready var group_option_button = $%GroupOptionButton
var area_names = []
var room_names = []
var groups = []

var query = {}

func _on_area_selected(idx):
	if idx > len(area_names) - 1:
		query.erase("area_name")
	else:
		var area_name = area_names[idx]
		if area_name:
			query["area_name"] = area_name

	list_entries()

func _on_room_selected(idx):
	if idx > len(room_names) - 1:
		query.erase("room_name")
	else:
		var room_name = room_names[idx]
		if room_name:
			query["room_name"] = room_name

	list_entries()

func _on_group_selected(idx):
	if idx > len(groups) - 1:
		query.erase("group")
	else:
		var group = groups[idx]
		if group:
			query["group"] = group

	list_entries()

func reset_option_buttons():
	area_option_button.clear()
	for an in area_names:
		area_option_button.add_item(an)
	area_option_button.add_item("Clear")

	room_option_button.clear()
	for rn in room_names:
		room_option_button.add_item(rn)
	room_option_button.add_item("Clear")

	group_option_button.clear()
	for g in groups:
		group_option_button.add_item(g)
	group_option_button.add_item("Clear")

#######################################################################
# db entries list

@onready var db_entries = $%DBEntries
const entry_label_scene = preload("res://addons/hotel/EntryLabel.tscn")

func list_entries():
	var entries = Hotel.query(query)

	for ch in db_entries.get_children():
		ch.queue_free()

	for e in entries:
		if "area_name" in e and e["area_name"] not in area_names:
			area_names.append(e["area_name"])
		if "room_name" in e and e["room_name"] not in room_names:
			room_names.append(e["room_name"])
		if "groups" in e:
			for g in e["groups"]:
				if not g in groups:
					groups.append(g)

		var lbl = entry_label_scene.instantiate()
		lbl.entry = e
		lbl.select_toggled.connect(toggle_entry_details.bind(e))

		if lbl.entry in selected_entries:
			lbl.initial_selected = true

		db_entries.call_deferred("add_child", lbl)

	area_names.sort()
	room_names.sort()
	groups.sort()


#######################################################################
# db detail entries list

@onready var db_entry_details = $%DBEntryDetails
const entry_detail_scene = preload("res://addons/hotel/EntryDetail.tscn")

var selected_entries = []

func toggle_entry_details(selected, entry):
	if not selected and entry in selected_entries:
		selected_entries.erase(entry)
		for ch in db_entry_details.get_children():
			if ch.entry == entry:
				ch.queue_free()
	elif selected:
		selected_entries.append(entry)
		var detail = entry_detail_scene.instantiate()
		detail.entry = entry
		detail.deselected.connect(deselect_entry.bind(entry))
		db_entry_details.call_deferred("add_child", detail)

func deselect_entry(entry):
	toggle_entry_details(false, entry)
	for lbl in db_entries.get_children():
		if lbl.entry == entry:
			lbl.set_selected(false)

#######################################################################
# updates

func _on_entry_update(entry):
	for ed in db_entry_details.get_children():
		if ed.entry["key"] == entry["key"]:
			ed.entry = entry
