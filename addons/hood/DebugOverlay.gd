extends CanvasLayer

var initial_vis = false
# var initial_vis = true

func _ready():
	if not Engine.is_editor_hint():
		set_visible(initial_vis)

func _unhandled_input(event):
	if Trolley.is_debug_toggle(event):
		set_visible(!visible)
