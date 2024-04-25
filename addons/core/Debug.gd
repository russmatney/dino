@tool
extends Node

var debugging = false

signal debug_toggled(debugging)

## ready ###############################################

func _ready():
	toggle_debug(debugging)

## input ###############################################

func _unhandled_input(event):
	if not Engine.is_editor_hint():
		if Trolls.is_debug_toggle(event):
			Debug.toggle_debug()
		elif Trolls.is_event(event, "slowmo"):
			Juice.slowmo_start()
		elif Trolls.is_released(event, "slowmo"):
			Juice.slowmo_stop()

# toggle debug ################################################

func toggle_debug(d=null):
	if d != null:
		debugging = d
	else:
		debugging = !debugging
	debug_toggled.emit(debugging)

###########################################################################
# debug overlay

var debug_overlay_scene = preload("res://addons/core/DebugOverlay.tscn")
var debug_overlay

func ensure_debug_overlay():
	if debug_overlay and is_instance_valid(debug_overlay):
		return

	debug_overlay = debug_overlay_scene.instantiate()
	add_child(debug_overlay)

signal debug_label_update(label_id, text, call_site)

func callsite_to_label_id(call_site):
	var lbl = ""
	lbl += call_site["source"].get_file().get_basename()
	lbl += " "
	lbl += call_site["function"]
	lbl += str(call_site["line"])
	# lbl = lbl.replace("/", "").replace(":", "").replace(".", "")
	return lbl

func debug_log(msg, msg2=null, msg3=null, msg4=null, msg5=null, msg6=null, msg7=null):
	debug_label(msg, msg2, msg3, msg4, msg5, msg6, msg7)
func debug_label(msg, msg2=null, msg3=null, msg4=null, msg5=null, msg6=null, msg7=null):
	var msg_array = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msg_array = msg_array.filter(func(m): return m)

	if Engine.is_editor_hint():
		Log.info("DEBUG_LABEL: ", msg_array)
		return

	ensure_debug_overlay()
	var s = get_stack()
	var call_site
	var label_id
	if len(s) > 1:
		call_site = s[1]
		label_id = callsite_to_label_id(call_site)
	else:
		label_id = "NONE"

	debug_label_update.emit(label_id, msg_array, call_site)


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
