@tool
extends Object
class_name Log

## misc ###########################################################################

static func log_prefix(stack):
	if len(stack) > 1:
		var call_site = stack[1]
		var basename = call_site["source"].get_file().get_basename()
		var line_num = str(call_site.get("line", 0))
		if call_site["source"].match("*/test/*"):
			return "{" + basename + ":" + line_num + "}: "
		elif call_site["source"].match("*/addons/*"):
			return "<" + basename + ":" + line_num + ">: "
		else:
			return "[" + basename + ":" + line_num + "]: "

static func color_wrap(s, color, use_color=true):
	if use_color:
		return "[color=%s]%s[/color]" % [color, s]
	else:
		return s

# supported colors:
# - black
# - red
# - green
# - yellow
# - blue
# - magenta
# - pink
# - purple
# - cyan
# - white
# - orange
# - gray

# supported tags:
# - b
# - i
# - u
# - s
# - indent
# - code
# - url
# - center
# - right
# - color
# - bgcolor
# - fgcolor

## _to_pretty ###########################################################################

# refactor into opts dict
# refactor into pluggable pretty printer
static func _to_pretty(msg, opts={}):
	var newlines = opts.get("newlines", false)
	var use_color = opts.get("color", true)
	var indent_level = opts.get("indent_level", 0)
	if not "indent_level" in opts:
		opts["indent_level"] = indent_level

	var max_array_size = 20
	var omit_vals_for_keys = ["layer_0/tile_data"]
	if not is_instance_valid(msg) and typeof(msg) == TYPE_OBJECT:
		return str(msg)
	if msg is Array or msg is PackedStringArray:
		if len(msg) > max_array_size:
			prn("[DEBUG]: truncating large array. total:", len(msg))
			msg = msg.slice(0, max_array_size - 1)
			if newlines:
				msg.append("...")

		var tmp = Log.color_wrap("[ ", "red", use_color)
		var last = len(msg) - 1
		for i in range(len(msg)):
			if newlines and last > 1:
				tmp += "\n\t"
			opts.indent_level += 1
			tmp += Log._to_pretty(msg[i], opts)
			if i != last:
				tmp += Log.color_wrap(", ", "red", use_color)
		tmp += Log.color_wrap(" ]", "red", use_color)
		return tmp
	elif msg is Dictionary:
		var tmp = Log.color_wrap("{ ", "red", use_color)
		var ct = len(msg)
		var last
		if len(msg) > 0:
			last = msg.keys()[-1]
		for k in msg.keys():
			var val
			if k in omit_vals_for_keys:
				val = "..."
			else:
				opts.indent_level += 1
				val = Log._to_pretty(msg[k], opts)
			if newlines and ct > 1:
				tmp += "\n\t" \
					+ range(indent_level)\
					.map(func(_i): return "\t")\
						.reduce(func(a, b): return str(a, b), "")
			if use_color:
				tmp += '[color=%s]"%s"[/color]: %s' % ["magenta", k, val]
			else:
				tmp += '"%s": %s' % [k, val]
			if last and str(k) != str(last):
				tmp += Log.color_wrap(", ", "red", use_color)
		tmp += Log.color_wrap(" }", "red", use_color)
		return tmp
	elif msg is String:
		if msg == "":
			return '""'
		# could check for supported tags in the string (see list above)
		# if msg.contains("["):
		# 	msg = "<ACTUAL-TEXT-REPLACED>"
		return Log.color_wrap(msg, "pink", use_color)
	elif msg is StringName:
		return str(Log.color_wrap("&", "orange", use_color), '"%s"' % msg)
	elif msg is NodePath:
		return str(Log.color_wrap("^", "orange", use_color), '"%s"' % msg)
	elif msg is Vector2:
		if use_color:
			return '([color=%s]%s[/color],[color=%s]%s[/color])' % ["purple", msg.x, "purple", msg.y]
		else:
			return '(%s,%s)' % [msg.x, msg.y]
	elif msg is Object and msg.has_method("data"):
		return Log._to_pretty(msg.data(), opts)
	elif msg is Object and msg.has_method("to_printable"):
		return Log._to_pretty(msg.to_printable(), opts)
	else:
		return str(msg)

## to_printable ###########################################################################

static func to_printable(msgs, opts={}):
	var stack = opts.get("stack", [])
	var pretty = opts.get("pretty", true)
	var newlines = opts.get("newlines", false)
	var use_color = opts.get("color", true)
	var m = ""
	if len(stack) > 0:
		var prefix = Log.log_prefix(stack)
		var c
		if prefix != null and prefix[0] == "[":
			c = "cyan"
		elif prefix != null and prefix[0] == "{":
			c = "green"
		elif prefix != null and prefix[0] == "<":
			c = "red"
		if pretty and use_color:
			m += "[color=%s]%s[/color]" % [c, prefix]
		else:
			m += prefix
	for msg in msgs:
		# add a space between msgs
		if pretty:
			m += "%s " % Log._to_pretty(msg, opts)
		else:
			m += "%s " % str(msg)
	return m.trim_suffix(" ")

static func is_not_default(v):
	return not v is String or (v is String and v != "ZZZDEF")

## public print fns ###########################################################################

static func pr(msg, msg2="ZZZDEF", msg3="ZZZDEF", msg4="ZZZDEF", msg5="ZZZDEF", msg6="ZZZDEF", msg7="ZZZDEF"):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var m = Log.to_printable(msgs, {stack=get_stack()})
	print_rich(m)

static func info(msg, msg2="ZZZDEF", msg3="ZZZDEF", msg4="ZZZDEF", msg5="ZZZDEF", msg6="ZZZDEF", msg7="ZZZDEF"):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var m = Log.to_printable(msgs, {stack=get_stack()})
	print_rich(m)

static func log(msg, msg2="ZZZDEF", msg3="ZZZDEF", msg4="ZZZDEF", msg5="ZZZDEF", msg6="ZZZDEF", msg7="ZZZDEF"):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var m = Log.to_printable(msgs, {stack=get_stack()})
	print_rich(m)

static func prn(msg, msg2="ZZZDEF", msg3="ZZZDEF", msg4="ZZZDEF", msg5="ZZZDEF", msg6="ZZZDEF", msg7="ZZZDEF"):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var m = Log.to_printable(msgs, {stack=get_stack(), newlines=true})
	print_rich(m)

static func warn(msg, msg2="ZZZDEF", msg3="ZZZDEF", msg4="ZZZDEF", msg5="ZZZDEF", msg6="ZZZDEF", msg7="ZZZDEF"):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var rich_msgs = msgs.duplicate()
	rich_msgs.push_front("[color=yellow][WARN][/color]")
	print_rich(Log.to_printable(rich_msgs, {stack=get_stack(), newlines=true}))
	var m = Log.to_printable(msgs, {stack=get_stack(), newlines=true, pretty=false})
	push_warning(m)

static func err(msg, msg2="ZZZDEF", msg3="ZZZDEF", msg4="ZZZDEF", msg5="ZZZDEF", msg6="ZZZDEF", msg7="ZZZDEF"):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var rich_msgs = msgs.duplicate()
	rich_msgs.push_front("[color=red][ERR][/color]")
	print_rich(Log.to_printable(rich_msgs, {stack=get_stack(), newlines=true}))
	var m = Log.to_printable(msgs, {stack=get_stack(), newlines=true, pretty=false})
	push_error(m)

static func error(msg, msg2="ZZZDEF", msg3="ZZZDEF", msg4="ZZZDEF", msg5="ZZZDEF", msg6="ZZZDEF", msg7="ZZZDEF"):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(Log.is_not_default)
	var rich_msgs = msgs.duplicate()
	rich_msgs.push_front("[color=red][ERR][/color]")
	print_rich(Log.to_printable(rich_msgs, {stack=get_stack(), newlines=true}))
	var m = Log.to_printable(msgs, {stack=get_stack(), newlines=true, pretty=false})
	push_error(m)
