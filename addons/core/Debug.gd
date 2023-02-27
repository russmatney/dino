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
# toggle debug

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
		prn("DEBUG_LABEL: ", msg_array)
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


############################################################################
# logger

func log_prefix(stack):
	if len(stack) > 0:
		var call_site = stack[1]
		if call_site["source"].match("*/addons/*"):
			return "<" + call_site["source"].get_file().get_basename() + ">: "
		else:
			return "[" + call_site["source"].get_file().get_basename() + "]: "

func to_printable(msgs, stack):
	var m = ""
	if len(stack) > 0:
		var prefix = log_prefix(stack)
		var color = "aquamarine" if prefix[0] == "[" else "peru"
		m += "[color=%s]%s[/color]" % [color, prefix]
	for ms in msgs:
		m += str(ms)
	return m

func prn(msg, msg2=null, msg3=null, msg4=null, msg5=null, msg6=null, msg7=null):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(func(m): return m)
	var m = to_printable(msgs, get_stack())
	print_rich(m)

func warn(msg, msg2=null, msg3=null, msg4=null, msg5=null, msg6=null, msg7=null):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(func(m): return m)
	var m = to_printable(msgs, get_stack())
	push_warning(m)

func err(msg, msg2=null, msg3=null, msg4=null, msg5=null, msg6=null, msg7=null):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(func(m): return m)
	var m = to_printable(msgs, get_stack())
	push_error(m)
