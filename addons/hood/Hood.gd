@tool
extends Node

func _ready():
	Debug.prn("Hood autoload ready")
	Debug.debug_label("Hood: loaded")

###########################################################################
# config

@onready var fallback_hud_scene = preload("res://addons/hood/HUD.tscn")

func set_hud_scene(preloaded_scene):
	Debug.prn("Overriding fallback HUD scene: ", preloaded_scene)
	fallback_hud_scene = preloaded_scene


###########################################################################
# ensure hud

var hud

func ensure_hud(hud_preload=null, p=null):
	ensure_jumbotron.call_deferred()

	Debug.pr("ensuring hud", hud_preload)
	if hud and is_instance_valid(hud):
		Debug.prn("HUD exists, nothing doing.")

		# support passing the player back into Hood
		if p:
			find_player(p)
		return

	if not hud_preload:
		hud_preload = fallback_hud_scene

	hud = hud_preload.instantiate()
	hud.ready.connect(_on_hud_ready)
	# make sure hud is included in usual scene lifecycle/clean up
	Navi.add_child_to_current(hud)
	if not player:
		find_player.call_deferred()

signal hud_ready

func _on_hud_ready():
	hud_ready.emit()

	# notify with any queued notifs
	for qn in queued_notifs:
		notif(qn[0], qn[1])

	for msgs in queued_notifs_dev:
		dev_notif.callv(msgs)

###########################################################################
# notifs

signal notification(text)

var queued_notifs = []

func notif(text, opts = {}):
	Debug.prn("notif: ", text)
	if not hud:
		queued_notifs.append([text, opts])
		Debug.prn("[INFO] no hud yet, queuing notification", [text, opts])
		return
	if typeof(opts) == TYPE_STRING:
		text += opts
		opts = {}
	opts["msg"] = text
	if not "ttl" in opts:
		opts["ttl"] = 3.0
	notification.emit(opts)

var queued_notifs_dev = []

# TODO only fire in dev mode?
func dev_notif(msg, msg2=null, msg3=null, msg4=null, msg5=null, msg6=null, msg7=null):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(func(m): return m)
	if not hud and queued_notifs_dev != null:
		queued_notifs_dev.append(msgs)
	else:
		msg = Debug.to_printable(msgs)
		notification.emit({msg=msg, rich=true, ttl=5.0})

###########################################################################
# jumbotron

var jumbotron_scene = preload("res://addons/hood/Jumbotron.tscn")
var jumbotron

func ensure_jumbotron():
	if jumbotron and is_instance_valid(jumbotron):
		return

	jumbotron = jumbotron_scene.instantiate()
	jumbotron.set_visible(false)
	Navi.add_child_to_current(jumbotron)

signal jumbo_closed

func jumbo_notif(header, body=null, key_or_action=null, action_label_text=null):
	if jumbotron:
		if header and header is Dictionary:
			body = header.get("body")
			key_or_action = header.get("key")
			key_or_action = header.get("action", key_or_action)
			action_label_text = header.get("action_label_text")
			header = header.get("header")

		jumbotron.header_text = header
		if body:
			jumbotron.body_text = body
		else:
			jumbotron.body_text = ""
		if key_or_action or action_label_text:
			jumbotron.action_hint.display(key_or_action, action_label_text)
		else:
			jumbotron.action_hint.hide()

		# pause game?
		jumbotron.fade_in()

		return jumbo_closed

###########################################################################
# find_player

# TODO remove in favor of Game.gd finding and passing in the player
signal found_player(player)

var player
var player_group = "player"


func find_player(p=null):
	if p:
		player = p

	if player:
		found_player.emit(player)
		return

	var ps = get_tree().get_nodes_in_group(player_group)

	if ps.size() > 1:
		Debug.warn("found multiple in player_group: ", player_group)
	if ps:
		player = ps[0]
		Debug.pr("found player: ", player)
	else:
		Debug.warn("could not find player, zero in player_group: ", player_group)
		return

	found_player.emit(player)
