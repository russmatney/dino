@tool
extends Node2D

@export var label: String
@export var destination: String

#############################################################

@onready var action_area = $ActionArea

var actions = [Action.mk({label_fn=func(): return label, fn=open_door})]

func _ready():
	action_area.register_actions(actions, {source=self})

	if label:
		set_label(label)

	if not destination == null and not ResourceLoader.exists(destination):
		Log.warn("Ghosts door destination does not exist!", destination)

func set_label(text):
	$Label.text = text

#############################################################

func open_door(_actor=null):
	Log.pr("open_door called, with dest: ", destination)
	Navi.nav_to(destination)
