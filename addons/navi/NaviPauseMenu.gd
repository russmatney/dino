extends CanvasLayer

@onready var button_list = $%NaviPauseButtonList

func set_focus():
	var chs = button_list.get_children()
	if len(chs) > 0:
		chs[0].grab_focus()

func ready() -> void:
	get_viewport().gui_focus_changed.connect(_on_focus_changed)

func _on_focus_changed(control:Control) -> void:
	if control != null:
		Debug.pr("focus changed!", control.name)
	else:
		Debug.pr("focus lost!")
