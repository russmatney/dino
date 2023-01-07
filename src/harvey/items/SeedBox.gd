tool
extends StaticBody2D

export (String, "carrot", "tomato", "onion") var produce_type = "carrot"

onready var produce_icon = $ProduceIcon

func _ready():
	produce_icon.animation = produce_type

func _on_Detectbox_body_entered(body:Node):
	if body.has_method("add_action") and body.has_method("pickup_seed"):
		body.add_action({"obj": body, "method": "pickup_seed", "arg": produce_type})


func _on_Detectbox_body_exited(body:Node):
	if body.has_method("remove_action"):
		body.remove_action({"obj": body, "method": "pickup_seed", "arg": produce_type})
