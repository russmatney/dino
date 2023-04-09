@tool
extends Node2D

@export var label: String
@export var destination: String

#############################################################


func _ready():
	if label:
		set_label(label)

	if not destination == null and not FileAccess.file_exists(destination):
		Debug.pr("[WARN] Ghosts door destination does not exist! ", destination)


func set_label(text):
	$Label.text = text


#############################################################


## Not stateless! depends checked _this_ door's destination
func open_door():
	Debug.pr("open_door called, with dest: ", destination)
	# TODO pause tree?
	# TODO animate door
	Ghosts.load_next_room(destination)


func _on_Detectbox_body_entered(body: Node):
	if body.is_in_group("player") and body.has_method("add_action"):
		if destination:
			body.add_action(self, "open_door")
		else:
			set_label("No Destination")


func _on_Detectbox_body_exited(body: Node):
	if body.is_in_group("player") and body.has_method("remove_action"):
		if destination:
			body.remove_action(self, "open_door")
		else:
			set_label("")
