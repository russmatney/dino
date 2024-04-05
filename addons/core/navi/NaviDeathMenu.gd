extends CanvasLayer

@onready var button_list = $%DeathButtonList

func set_focus():
	var chs = button_list.get_children()
	if len(chs) > 0:
		chs[0].grab_focus()
