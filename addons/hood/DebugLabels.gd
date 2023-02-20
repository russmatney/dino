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

func debug_label_update(label_id, text_arr):
	var lbl = container.get_node_or_null(label_id)
	if not lbl:
		lbl = label_scene.instantiate()
		lbl.name = label_id
		container.add_child(lbl)

	var text = "[right]"
	for t in text_arr:
		text += str(t, " ")
	lbl.text = text
