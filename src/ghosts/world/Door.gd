tool
extends Node2D

export(String) var label
export(String) var destination

#############################################################

func _ready():
	if label:
		set_label(label)

	if destination and not File.new().file_exists(destination):
		print("[WARN] Ghosts door destination does not exist! ", destination)

func set_label(text):
	$Label.text = text

#############################################################

## Not stateless! depends on _this_ door's destination
func open_door():
	print("open_door called, with dest: ", destination)
	# TODO pause tree?
	# TODO animate door
	Ghosts.load_next_room(destination)

func _on_Detectbox_body_entered(body:Node):
	if body.is_in_group("player") and body.has_method("add_action"):
		if destination:
			body.add_action(self, "open_door")
		else:
			set_label("No Destination")

func _on_Detectbox_body_exited(body:Node):
	if body.is_in_group("player") and body.has_method("remove_action"):
		if destination:
			body.remove_action(self, "open_door")
		else:
			set_label("")
