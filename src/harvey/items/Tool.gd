tool
extends KinematicBody2D


export (String, "watering-pail", "shovel") var tool_type = "watering-pail"

onready var tool_icon = $ToolIcon

func _ready():
	tool_icon.animation = tool_type

func _on_Detectbox_body_entered(body:Node):
	if body.has_method("add_action") and body.has_method("pickup_tool"):
		body.add_action({"obj": body, "method": "pickup_tool", "arg": tool_type})


func _on_Detectbox_body_exited(body:Node):
	if body.has_method("remove_action"):
		body.remove_action({"obj": body, "method": "pickup_tool", "arg": tool_type})
