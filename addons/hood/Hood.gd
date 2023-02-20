@tool
extends Node

func _ready():
	prn("autoload ready")
	print("<Hood> autoload ready")

	debug_label("Hood: loaded")

###########################################################################
# config

@onready var fallback_hud_scene = preload("res://addons/hood/HUD.tscn")

func set_hud_scene(preloaded_scene):
	prn("Overriding fallback HUD scene: ", preloaded_scene)
	fallback_hud_scene = preloaded_scene


###########################################################################
# ensure hud

var hud

func ensure_hud(hud_preload=null):
	prn("ensuring hud")
	if hud and is_instance_valid(hud):
		prn("HUD exists, nothing doing.")
		return

	if not hud_preload:
		hud_preload = fallback_hud_scene

	hud = hud_preload.instantiate()
	hud.ready.connect(_on_hud_ready)
	# make sure hud is included in usual scene lifecycle/clean up
	Navi.add_child_to_current(hud)
	Hood.call_deferred("find_player")

signal hud_ready

func _on_hud_ready():
	emit_signal("hud_ready")

	# notify with any queued notifs
	for qn in queued_notifs:
		notif(qn[0], qn[1])


###########################################################################
# notifs

signal notification(text)

var queued_notifs = []

func notif(text, opts = {}):
	prn("notif: ", text)
	if not hud:
		queued_notifs.append([text, opts])
		prn("[INFO] no hud yet, queuing notification")
		return
	if typeof(opts) == TYPE_STRING:
		text += opts
		opts = {}
	opts["msg"] = text
	if not "ttl" in opts:
		opts["ttl"] = 3.0
	emit_signal("notification", opts)

###########################################################################
# debug overlay

var debug_overlay_scene = preload("res://addons/hood/DebugOverlay.tscn")
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

###########################################################################
# find_player

signal found_player(player)

var player
var player_group = "player"


func find_player():
	if player:
		emit_signal("found_player", player)
		return

	var ps = get_tree().get_nodes_in_group(player_group)

	if ps.size() > 1:
		prn("[WARN] found multiple in player_group: ", player_group)
	if ps:
		player = ps[0]
		prn("found player: ", player)
	else:
		prn("[WARN] could not find player, zero in player_group: ", player_group)
		return

	emit_signal("found_player", player)

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
		var color = "aquamarine"
		m += "[color=%s]%s[/color]" % [color, log_prefix(get_stack())]
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
