@tool
extends CanvasLayer

@onready var games_list = $%GamesList

func _ready():
	if Engine.is_editor_hint():
		request_ready()

	DJ.resume_menu_song()

	var chs = games_list.get_children()
	if len(chs) > 0:
		chs[0].grab_focus()
