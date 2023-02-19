@tool
extends PanelContainer

###########################################################################
# helper

@export var create_new_label: bool :
	set(v):
		create_new_label = v
		if Engine.is_editor_hint():
			Hood.debug_label("Width", str("width: ", 360))

###########################################################################
# ready

@onready var container = $VBoxContainer

func _ready():
	Hood.debug_label_update.connect(debug_label_update)

###########################################################################
# label update

var label_scene = preload("res://addons/hood/DebugLabel.tscn")

func debug_label_update(node_name, text):
	var lbl = container.get_node_or_null(node_name)
	if not lbl:
		lbl = label_scene.instantiate()
		lbl.name = node_name
		container.add_child(lbl)

	lbl.text = "[right]" + text
