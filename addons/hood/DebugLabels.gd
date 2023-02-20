@tool
extends PanelContainer

###########################################################################
# helper

@export var create_new_label: bool :
	set(v):
		create_new_label = v
		if Engine.is_editor_hint():
			debug_label_update("DEBUG", ["width", 360])

###########################################################################
# ready

@onready var container = $VBoxContainer

func _ready():
	Hood.debug_label_update.connect(debug_label_update)

###########################################################################
# label update

var label_scene = preload("res://addons/hood/DebugLabel.tscn")
var debug_label_group = "debug_labels"
var debug_label_db = {}

func debug_label_update(label_id, data_arr, call_site={}):
	if not container:
		return

	var label = container.get_node_or_null(label_id)
	if not label:
		label = label_scene.instantiate()
		label.add_to_group(debug_label_group)
		label.name = label_id
		container.add_child(label)

	# update local data-dict
	debug_label_db[label_id] = {"call_site": call_site, "data_arr": data_arr, "label": label}

	var text = "[right]"
	for t in data_arr:
		text += str(t, " ")
	label.text = text
	label.set_scale(Vector2i(16, 16))
	rearrange_labels()

###########################################################################
# rearrange labels

func rearrange_labels():
	# Hood.prn("data: ", debug_label_db.values())

	var by_source = {}
	for label in debug_label_db.values():
		var source = "None"
		if "call_site" in label and label["call_site"] != null and "source" in label["call_site"]:
			source = label["call_site"]["source"].get_file().get_basename()

		if source in by_source:
			by_source[source].append(label)
		else:
			by_source[source] = []

	var children_by_source = []
	for source in by_source.keys():
		var source_label_id = str("Group label: ", source)
		var source_label = container.get_node_or_null(source_label_id)
		if not source_label:
			source_label = label_scene.instantiate()
			source_label.add_to_group(debug_label_group)
			source_label.name = source_label_id
			container.add_child(source_label)

		children_by_source.append(source_label)

		for label in by_source[source]:
			children_by_source.append(label["label"])

	for c in children_by_source:
		container.move_child(c, -1)
