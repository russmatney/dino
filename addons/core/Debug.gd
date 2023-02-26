@tool
extends Node

var debugging = false

signal debug_toggled(debugging)

################################################
# ready

func _ready():
	toggle_debug(debugging)

################################################
# input

func _unhandled_input(event):
	if not Engine.is_editor_hint():
		if Trolley.is_debug_toggle(event):
			toggle_debug()
		elif Trolley.is_event(event, "slowmo"):
			slowmo_start()
		elif Trolley.is_event_released(event, "slowmo"):
			slowmo_stop()

################################################
# input

func toggle_debug(d=null):
	if d != null:
		debugging = d
	else:
		debugging = !debugging
	debug_toggled.emit(debugging)

################################################
# slowmo toggle

func slowmo_start():
	Hood.notif("Slooooooow mooooootion")
	Cam.start_slowmo("debug_overlay_slowmo", 0.3)

func slowmo_stop():
	Hood.notif("Back to full speed")
	Cam.stop_slowmo("debug_overlay_slowmo")
