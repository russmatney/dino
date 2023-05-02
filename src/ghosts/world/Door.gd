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

	if not destination == null and not FileAccess.file_exists(destination):
		Debug.warn("Ghosts door destination does not exist!", destination)


func set_label(text):
	$Label.text = text


#############################################################


## Not stateless! depends on _this_ door's destination
func open_door(_actor=null):
	Debug.pr("open_door called, with dest: ", destination)
	# TODO pause tree?
	# TODO animate door
	Ghosts.load_next_room(destination)

