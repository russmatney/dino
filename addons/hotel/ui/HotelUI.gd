@tool
extends Control

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

#######################################################################
# rebuild button

func _on_rebuild_db_button_pressed():
	Debug.prn(&"Rebuilding hotel db -----------------------------------")
	Hotel.recreate_db()
	list_entries()
	Debug.prn(&"Rebuilt hotel db --------------------------------------")


#######################################################################
# ready

func _ready():
	Hotel.register(self)

	list_entries()
	reset_option_buttons()

	zone_option_button.item_selected.connect(_on_zone_selected)
	room_option_button.item_selected.connect(_on_room_selected)
	group_option_button.item_selected.connect(_on_group_selected)
	has_group_toggle.pressed.connect(_on_has_group_toggle)
	is_root_toggle.pressed.connect(_on_is_root_toggle)

	Hotel.entry_updated.connect(_on_entry_update)


func check_out(data):
	query = data.get("query", query)

func hotel_data():
	return {query=query}

#######################################################################
# option buttons

# consider drying up this pattern

@onready var zone_option_button = $%ZoneOptionButton
@onready var room_option_button = $%RoomOptionButton
@onready var group_option_button = $%GroupOptionButton
@onready var has_group_toggle = $%HasGroupToggle
@onready var is_root_toggle = $%IsRootToggle
var zone_names = []
var room_names = []
var groups = []

var query = {has_group=true,}

func _on_zone_selected(idx):
	if idx > len(zone_names) - 1:
		query.erase("zone_name")
	else:
		var zone_name = zone_names[idx]
		if zone_name:
			query["zone_name"] = zone_name

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

func _on_has_group_toggle():
	if has_group_toggle.button_pressed:
		query["has_group"] = true
	else:
		query.erase("has_group")

	list_entries()

func _on_is_root_toggle():
	if is_root_toggle.button_pressed:
		query["is_root"] = true
	else:
		query.erase("is_root")

	list_entries()

func reset_option_buttons():
	zone_option_button.clear()
	for an in zone_names:
		zone_option_button.add_item(an)
	zone_option_button.add_item("Clear")

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
const entry_label_scene = preload("res://addons/hotel/ui/EntryLabel.tscn")

func list_entries():
	var entries = Hotel.query(query)

	for ch in db_entries.get_children():
		ch.queue_free()

	for e in entries:
		if "zone_name" in e and e["zone_name"] not in zone_names:
			zone_names.append(e["zone_name"])
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

		db_entries.add_child.call_deferred(lbl)

	zone_names.sort()
	room_names.sort()
	groups.sort()


#######################################################################
# db detail entries list

@onready var db_entry_details = $%DBEntryDetails
const entry_detail_scene = preload("res://addons/hotel/ui/EntryDetail.tscn")

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
		db_entry_details.add_child.call_deferred(detail)

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
