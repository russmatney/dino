@tool
extends PanelContainer

###########################################################################
# helper

@export var create_new_label: bool :
	set(v):
		create_new_label = v
		if Engine.is_editor_hint():
			_on_debug_label_update("DEBUG", ["width", 360])

###########################################################################
# ready

var container

func _ready():
	Debug.debug_label_update.connect(_on_debug_label_update)
	container = get_node("%LabelsContainer")

	Debug.debug_toggled.connect(_on_debug_toggled)

func _on_debug_toggled(debugging):
	if debugging:
		rearrange_labels()

###########################################################################
# label update

var label_scene = preload("res://addons/core/DebugLabel.tscn")
var debug_label_group = "debug_labels"
var debug_label_db = {}

func _on_debug_label_update(label_id, data_arr, call_site={}):
	if not container:
		return

	var db_label
	if label_id in debug_label_db:
		db_label = debug_label_db[label_id]
	else:
		var label = label_scene.instantiate()
		label.add_to_group(debug_label_group, true)
		label.name = label_id
		db_label = {"call_site": call_site, "data_arr": data_arr, "label": label}

	var text = "[right]"
	for t in data_arr:
		text += str(t, " ")
	db_label["label"].text = text

	debug_label_db[label_id] = db_label

###########################################################################
# rearrange labels

var ignored_sources = []

func _toggle_source(src):
	if src in ignored_sources:
		ignored_sources.erase(src)
	else:
		ignored_sources.append(src)

	rearrange_labels()

func rearrange_labels():
	var by_source = {}
	for label in debug_label_db.values():
		var source = "None"
		if "call_site" in label and label["call_site"] != null and "source" in label["call_site"]:
			# TODO reuse some of the callsite_to_label_id
			# maybe in Util or some other meta namespace
			source = label["call_site"]["source"].get_file().get_basename()

		if source in by_source:
			by_source[source].append(label)
		else:
			by_source[source] = []

	var children_sorted_by_source = []
	for source in by_source.keys():
		var source_label_id = str("Group label ", source)
		var source_label = container.get_node_or_null(source_label_id)
		if not source_label:
			source_label = label_scene.instantiate()
			source_label.add_to_group(debug_label_group, true)
			source_label.name = source_label_id
			container.add_child(source_label)

		source_label.text = "[right]Source: [color=crimson]" + source + "[/color]"

		var toggle_source_btn = Button.new()
		if source in ignored_sources:
			toggle_source_btn.text = str("Show ", source, " labels")
		else:
			toggle_source_btn.text = str("Hide ", source, " labels")
		toggle_source_btn.pressed.connect(_toggle_source.bind(source))

		children_sorted_by_source.append(toggle_source_btn)
		# children_sorted_by_source.append(source_label)

		if not source in ignored_sources:
			for label in by_source[source]:
				children_sorted_by_source.append(label["label"])

	for c in container.get_children():
		container.remove_child(c)

	for c in children_sorted_by_source:
		container.add_child(c)


func _on_rearrange_labels_pressed():
	rearrange_labels()


const hotel_ui_scene = preload("res://addons/hotel/HotelUI.tscn")
var hotel_ui

func _on_toggle_hotel_db_pressed():
	if hotel_ui and is_instance_valid(hotel_ui):
		hotel_ui.queue_free()
	else:
		hotel_ui = hotel_ui_scene.instantiate()
		$%ToggleHotelDB.add_sibling(hotel_ui)


const dj_turntable_scene = preload("res://addons/dj/TurnTable.tscn")
var dj_turntable

func _on_toggle_dj_turn_table_pressed():
	if dj_turntable and is_instance_valid(dj_turntable):
		dj_turntable.queue_free()
	else:
		dj_turntable = dj_turntable_scene.instantiate()
		$%ToggleDJTurnTable.add_sibling(dj_turntable)
