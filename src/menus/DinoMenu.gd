@tool
extends CanvasLayer


func _ready():
	if Engine.is_editor_hint():
		request_ready()

	DJ.resume_menu_song()
