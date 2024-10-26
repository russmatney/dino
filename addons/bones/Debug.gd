@tool
extends Node

var debugging = false

signal debug_toggled(debugging)

## ready ###############################################

func _ready():
	toggle_debug(debugging)

## input ###############################################

# func _unhandled_input(event):
# 	if not Engine.is_editor_hint():
# 		if Trolls.is_debug_toggle(event):
# 			Debug.toggle_debug()
# 		elif Trolls.is_slowmo(event):
# 			Juice.slowmo_start()
# 		elif Trolls.is_slowmo_released(event):
# 			Juice.slowmo_stop()

# toggle debug ################################################

func toggle_debug(d=null):
	if d != null:
		debugging = d
	else:
		debugging = !debugging
	debug_toggled.emit(debugging)


## focus ##########################################################################

## is the window focused?
# https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html#window-focus
var focused := true

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			focused = false
		NOTIFICATION_APPLICATION_FOCUS_IN:
			focused = true

## notifications ##########################################################################

signal debug_notification(notif)

func notif(text, opts = {}):
	if text is Dictionary:
		opts.merge(text)
		text = opts.get("text", opts.get("msg"))
	if typeof(opts) == TYPE_STRING or not opts is Dictionary:
		text += str(opts)
		opts = {}
	opts["text"] = text
	if not "ttl" in opts:
		opts["ttl"] = 3.0
	(func(): debug_notification.emit(opts)).call_deferred()
