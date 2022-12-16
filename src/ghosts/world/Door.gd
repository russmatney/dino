tool
extends Node2D

export(String) var label

export(PackedScene) var destination

#############################################################

func _ready():
	if label:
		$Label.text = label

#############################################################

## Not stateless! depends on _this_ door's destination
func open_door():
	# TODO pause tree?
	# TODO animate door
	# TODO load destination scene
	print("open_door called, with dest: ", destination)

	# TODO i think this needs to be a path, maybe write a packed scene version?
	Navi.nav_to(destination)


func _on_Detectbox_body_entered(body:Node):
	if body.is_in_group("player") and body.has_method("add_action"):
		body.add_action(self, "open_door")

func _on_Detectbox_body_exited(body:Node):
	if body.is_in_group("player") and body.has_method("remove_action"):
		body.remove_action(self, "open_door")
