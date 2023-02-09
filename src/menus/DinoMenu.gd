@tool
extends Control


func _ready():
	if Engine.editor_hint:
		request_ready()

	DJ.resume_menu_song()
