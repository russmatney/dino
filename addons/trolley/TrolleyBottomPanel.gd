@tool
extends Control


func _ready():
	if Engine.is_editor_hint():
		request_ready()
