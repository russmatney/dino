tool
extends Node2D

export(String) var label

#############################################################

func _ready():
	if label:
		$Label.text = label

#############################################################

func _on_Detectbox_body_entered(body:Node):
	pass # Replace with function body.


func _on_Detectbox_body_exited(body:Node):
	pass # Replace with function body.
