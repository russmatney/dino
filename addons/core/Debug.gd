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

func to_pretty(msg, newlines=false):
	if msg is Array or msg is PackedStringArray:
		var tmp = "[ "
		var last = len(msg) - 1
		for i in range(len(msg)):
			if newlines and last > 1:
				tmp += "\n\t"
			tmp += to_pretty(msg[i], newlines)
			if i != last:
				tmp += ", "
		tmp += " ]"
		return tmp
	elif msg is Dictionary:
		var tmp = "{ "
		var ct = len(msg)
		var last
		if len(msg) > 0:
			last = msg.keys()[-1]
		for k in msg.keys():
			var val = to_pretty(msg[k], newlines)
			if newlines and ct > 1:
				tmp += "\n\t"
			tmp += '[color=%s]"%s"[/color]: %s' % ["cadet_blue", k, val]
			if last and k != last:
				tmp += ", "
		tmp += " }"
		return tmp
	elif msg is String:
		return '[color=%s]%s[/color]' % ["dark_gray", msg]
	elif msg is StringName:
		return '[color=%s]&[/color]"%s"' % ["coral", msg]
	elif msg is NodePath:
		return '[color=%s]^[/color]"%s"' % ["coral", msg]
	elif msg is Vector2:
		return '([color=%s]%s[/color],[color=%s]%s[/color])' % ["cornflower_blue", msg.x, "cornflower_blue", msg.y]
	else:
		return str(msg)

func to_printable(msgs, stack, newlines=false):
	var m = ""
	if len(stack) > 0:
		var prefix = log_prefix(stack)
		var color = "aquamarine" if prefix[0] == "[" else "peru"
		m += "[color=%s]%s[/color]" % [color, prefix]
	for msg in msgs:
		# add a space between msgs
		m += to_pretty(msg, newlines) + " "
	return m

func pr(msg, msg2=null, msg3=null, msg4=null, msg5=null, msg6=null, msg7=null):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(func(m): return m)
	var m = to_printable(msgs, get_stack())
	print_rich(m)

func prn(msg, msg2=null, msg3=null, msg4=null, msg5=null, msg6=null, msg7=null):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(func(m): return m)
	var m = to_printable(msgs, get_stack(), true)
	print_rich(m)

func warn(msg, msg2=null, msg3=null, msg4=null, msg5=null, msg6=null, msg7=null):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(func(m): return m)
	var m = to_printable(msgs, get_stack(), true)
	push_warning(m)

func err(msg, msg2=null, msg3=null, msg4=null, msg5=null, msg6=null, msg7=null):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(func(m): return m)
	var m = to_printable(msgs, get_stack(), true)
	push_error(m)
