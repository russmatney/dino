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
