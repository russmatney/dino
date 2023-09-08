@tool
extends Node

var debugging = false

signal debug_toggled(debugging)

################################################
# ready

func _ready():
	toggle_debug(debugging)

################################################
# toggle debug

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
	if len(stack) > 1:
		var call_site = stack[1]
		if call_site["source"].match("*/addons/*"):
			return "<" + call_site["source"].get_file().get_basename() + ">: "
		else:
			return "[" + call_site["source"].get_file().get_basename() + "]: "

func color_wrap(s, color, use_color=true):
	if use_color:
		return "[color=%s]%s[/color]" % [color, s]
	else:
		return s

var omit_vals_for_keys = ["layer_0/tile_data"]

var max_array_size = 20

# TODO refactor into opts dict
# TODO refactor into pluggable pretty printer
func to_pretty(msg, newlines=false, use_color=true, indent_level=0):
	if msg is Array or msg is PackedStringArray:
		if len(msg) > max_array_size:
			prn("[DEBUG]: truncating large array. total:", len(msg))
			msg = msg.slice(0, max_array_size - 1)
			if newlines:
				msg.append("...")

		var tmp = color_wrap("[ ", "crimson", use_color)
		var last = len(msg) - 1
		for i in range(len(msg)):
			if newlines and last > 1:
				tmp += "\n\t"
			tmp += to_pretty(msg[i], newlines, use_color, indent_level + 1)
			if i != last:
				tmp += color_wrap(", ", "crimson", use_color)
		tmp += color_wrap(" ]", "crimson", use_color)
		return tmp
	elif msg is Dictionary:
		var tmp = color_wrap("{ ", "crimson", use_color)
		var ct = len(msg)
		var last
		if len(msg) > 0:
			last = msg.keys()[-1]
		for k in msg.keys():
			var val
			if k in omit_vals_for_keys:
				val = "..."
			else:
				val = to_pretty(msg[k], newlines, use_color, indent_level + 1)
			if newlines and ct > 1:
				tmp += "\n\t" \
					+ range(indent_level)\
					.map(func(_i): return "\t")\
						.reduce(func(a, b): return str(a, b), "")
			if use_color:
				tmp += '[color=%s]"%s"[/color]: %s' % ["cadet_blue", k, val]
			else:
				tmp += '"%s": %s' % [k, val]
			if last and str(k) != str(last):
				tmp += color_wrap(", ", "crimson", use_color)
		tmp += color_wrap(" }", "crimson", use_color)
		return tmp
	elif msg is String:
		if msg == "":
			return '""'
		# TODO check for known tags in here, like 'center'/'right'/'jump'/etc
		# if msg.contains("["):
		# 	msg = "<ACTUAL-TEXT-REPLACED>"
		return color_wrap(msg, "dark_gray", use_color)
	elif msg is StringName:
		return str(color_wrap("&", "coral", use_color), '"%s"' % msg)
	elif msg is NodePath:
		return str(color_wrap("^", "coral", use_color), '"%s"' % msg)
	elif msg is Vector2:
		if use_color:
			return '([color=%s]%s[/color],[color=%s]%s[/color])' % ["cornflower_blue", msg.x, "cornflower_blue", msg.y]
		else:
			return '(%s,%s)' % [msg.x, msg.y]
	elif msg is PandoraEntity and msg.has_method("data"):
		return to_pretty(msg.data(), newlines, use_color, indent_level)
	else:
		return str(msg)

func to_printable(msgs, stack=[], newlines=false, pretty=true, use_color=true):
	var m = ""
	if len(stack) > 0:
		var prefix = log_prefix(stack)
		var c = "aquamarine" if prefix != null and prefix[0] == "[" else "peru"
		if pretty and use_color:
			m += "[color=%s]%s[/color]" % [c, prefix]
		else:
			m += prefix
	for msg in msgs:
		# add a space between msgs
		if pretty:
			m += to_pretty(msg, newlines, use_color) + " "
		else:
			m += str(msg) + " "
	return m

var default_val = "somecrazydefault"
func is_not_def(v):
	return not v is String or (v is String and v != "somecrazydefault")

func pr(msg, msg2=default_val, msg3=default_val, msg4=default_val, msg5=default_val, msg6=default_val, msg7=default_val):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(is_not_def)
	var m = to_printable(msgs, get_stack())
	print_rich(m)

func info(msg, msg2=default_val, msg3=default_val, msg4=default_val, msg5=default_val, msg6=default_val, msg7=default_val):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(is_not_def)
	var m = to_printable(msgs, get_stack())
	print_rich(m)

func log(msg, msg2=default_val, msg3=default_val, msg4=default_val, msg5=default_val, msg6=default_val, msg7=default_val):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(is_not_def)
	var m = to_printable(msgs, get_stack())
	print_rich(m)

func prn(msg, msg2=default_val, msg3=default_val, msg4=default_val, msg5=default_val, msg6=default_val, msg7=default_val):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(is_not_def)
	var m = to_printable(msgs, get_stack(), true)
	print_rich(m)

func warn(msg, msg2=default_val, msg3=default_val, msg4=default_val, msg5=default_val, msg6=default_val, msg7=default_val):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(is_not_def)
	var rich_msgs = msgs.duplicate()
	rich_msgs.push_front("[color=yellow][WARN][/color]")
	print_rich(to_printable(rich_msgs, get_stack(), true))
	var m = to_printable(msgs, get_stack(), true, false)
	push_warning(m)

func err(msg, msg2=default_val, msg3=default_val, msg4=default_val, msg5=default_val, msg6=default_val, msg7=default_val):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(is_not_def)
	var rich_msgs = msgs.duplicate()
	rich_msgs.push_front("[color=red][ERR][/color]")
	print_rich(to_printable(rich_msgs, get_stack(), true))
	var m = to_printable(msgs, get_stack(), true, false)
	push_error(m)
