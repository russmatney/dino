@tool
extends Node

# TODO logger
func prn(msg, msg2=null, msg3=null):
	if msg3:
		print("[HOOD]: ", msg, msg2, msg3)
	elif msg2:
		print("[HOOD]: ", msg, msg2)
	elif msg:
		print("[HOOD]: ", msg)

func _ready():
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

signal debug_label_update(label_id, text)

func debug_label(text_arr):
	if text_arr is String:
		text_arr = [text_arr]
	var call_site = get_stack()[1]
	var label_id = ""
	label_id += call_site["source"]
	label_id += str(call_site["line"])
	label_id = label_id.replace("/", "").replace(":", "").replace(".", "")
	ensure_debug_overlay()
	emit_signal("debug_label_update", label_id, text_arr)

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
