@tool
extends Node

func _ready():
	Debug.prn("autoload ready")
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

func ensure_hud(hud_preload=null):
	call_deferred("ensure_jumbotron")

	Debug.prn("ensuring hud")
	if hud and is_instance_valid(hud):
		Debug.prn("HUD exists, nothing doing.")
		return

	if not hud_preload:
		hud_preload = fallback_hud_scene

	hud = hud_preload.instantiate()
	hud.ready.connect(_on_hud_ready)
	# make sure hud is included in usual scene lifecycle/clean up
	Navi.add_child_to_current(hud)
	call_deferred("find_player")

signal hud_ready

func _on_hud_ready():
	hud_ready.emit()

	# notify with any queued notifs
	for qn in queued_notifs:
		notif(qn[0], qn[1])

###########################################################################
# notifs

signal notification(text)

var queued_notifs = []

func notif(text, opts = {}):
	Debug.prn("notif: ", text)
	if not hud:
		queued_notifs.append([text, opts])
		Debug.prn("[INFO] no hud yet, queuing notification")
		return
	if typeof(opts) == TYPE_STRING:
		text += opts
		opts = {}
	opts["msg"] = text
	if not "ttl" in opts:
		opts["ttl"] = 3.0
	notification.emit(opts)

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

func jumbo_notif(header, body=null, key_or_action=null, action_label_text=null):
	if jumbotron:
		jumbotron.header_text = header
		if body:
			jumbotron.body_text = body
		if key_or_action or action_label_text:
			jumbotron.action_hint.display(key_or_action, action_label_text)

		# pause game?
		jumbotron.fade_in()

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
		Debug.warn("found multiple in player_group: ", player_group)
	if ps:
		player = ps[0]
		Debug.pr("found player: ", player)
	else:
		Debug.warn("could not find player, zero in player_group: ", player_group)
		return

	emit_signal("found_player", player)
