@tool
extends Node

func _ready():
	Debug.prn("Hood autoload ready")
	Debug.debug_label("Hood: loaded")

###########################################################################
# config

# we can't preload here b/c this scene depends on the Hood autoload (this script)
var fallback_hud_scene = "res://addons/hood/HUD.tscn"

func set_hud_scene(hud_scene_or_string):
	Debug.prn("Overriding fallback HUD scene: ", hud_scene_or_string)
	fallback_hud_scene = hud_scene_or_string

###########################################################################
# ensure hud

var hud

func ensure_hud(hud_preload=null):
	Debug.pr("ensuring hud", hud_preload)
	if hud and is_instance_valid(hud):
		Debug.prn("HUD exists, nothing doing.")
		return

	if not hud_preload:
		if fallback_hud_scene is String:
			fallback_hud_scene = load(fallback_hud_scene)
		hud_preload = fallback_hud_scene

	hud = hud_preload.instantiate()
	if not hud:
		Debug.err("failed to instantiate HUD scene", hud_preload)
		return

	hud.ready.connect(_on_hud_ready)
	# make sure hud is included in usual scene lifecycle/clean up
	Navi.add_child_to_current(hud)

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
	if typeof(opts) == TYPE_STRING or not opts is Dictionary:
		text += str(opts)
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
