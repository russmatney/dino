extends CanvasLayer

var initial_vis = false
# var initial_vis = true


func _ready():
	if not Engine.is_editor_hint():
		set_visible(initial_vis)


func _unhandled_input(event):
	if Trolley.is_debug_toggle(event):
		set_visible(!visible)
	elif Trolley.is_event(event, "slowmo"):
		slowmo_start()
	elif Trolley.is_event_released(event, "slowmo"):
		slowmo_stop()

func slowmo_start():
	Hood.notif("Slooooooow mooooootion")
	Cam.start_slowmo("debug_overlay_slowmo", 0.3)

func slowmo_stop():
	Hood.notif("Back to full speed")
	Cam.stop_slowmo("debug_overlay_slowmo")
