@tool
extends Node2D

@export var label: String
@export var destination: String

#############################################################

var actions = [Action.mk({label_fn=func(): return label, fn=open_door})]

func _ready():
	if label:
		set_label(label)

	if not destination == null and not ResourceLoader.exists(destination):
		Log.warn("Ghosts door destination does not exist!", destination)

func set_label(text):
	$Label.text = text

#############################################################

func open_door(_actor=null):
	Navi.nav_to(destination)
