@tool
extends CanvasLayer

@onready var games_list = $%GamesList

func _ready():
	if Engine.is_editor_hint():
		request_ready()

	DJ.resume_menu_song()

	get_viewport().gui_focus_changed.connect(_on_focus_changed)

	var chs = games_list.get_children()
	if len(chs) > 0:
		chs[0].grab_focus()

func _on_focus_changed(control:Control) -> void:
	if control != null:
		Debug.pr("focus changed!", control.name)
	else:
		Debug.pr("focus lost!")
