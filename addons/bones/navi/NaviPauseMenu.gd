extends CanvasLayer

@onready var button_list := $%NaviPauseButtonList

func set_focus() -> void:
	var chs := button_list.get_children()
	if len(chs) > 0:
		for ch: Node in chs:
			if ch is Control:
				(ch as Control).grab_focus()
				break
