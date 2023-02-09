@tool
extends Control


func _ready():
	if Engine.editor_hint:
		request_ready()
