tool
extends StaticBody2D

func _ready():
	pass

func _on_Detectbox_body_entered(body:Node):
	if body.has_method("add_action"):
		if body.has_method("has_produce") and body.has_produce() and body.has_method("deliver_produce"):
			body.add_action({"obj": body, "method": "deliver_produce"})

func _on_Detectbox_body_exited(body:Node):
	if body.has_method("remove_action"):
		body.remove_action({"obj": body, "method": "deliver_produce"})
