@tool
extends Node

# func _ready():
# 	Log.prn("Hood autoload ready")
# 	Debug.debug_label("Hood: loaded")

###########################################################################
# config

# we can't preload here b/c this scene depends on the Hood autoload (this script)
var fallback_hud_scene = "res://addons/hood/HUD.tscn"

func set_hud_scene(hud_scene_or_string):
	Log.prn("Overriding fallback HUD scene: ", hud_scene_or_string)
	fallback_hud_scene = hud_scene_or_string

###########################################################################
# ensure hud

var hud

func ensure_hud(hud_scene=null):
	if hud and is_instance_valid(hud):
		if hud_scene == null:
			hud_scene = load(fallback_hud_scene)
		var expected_path
		if hud_scene is String:
			expected_path = hud_scene
		elif hud_scene is PackedScene:
			expected_path = hud_scene.resource_path

		if expected_path == hud.scene_file_path:
			# do nothing if correct hud already loaded
			return
		else:
			hud.queue_free()

	if not hud_scene:
		if fallback_hud_scene is String:
			fallback_hud_scene = load(fallback_hud_scene)
		hud_scene = fallback_hud_scene

	if hud_scene is String:
		hud_scene = load(hud_scene)
	if hud_scene == null:
		Log.err("no hud scene, cannot ensure", hud_scene)
		return
	hud = hud_scene.instantiate()
	if not hud:
		Log.err("failed to instantiate HUD scene", hud_scene)
		return

	hud.ready.connect(_on_hud_ready)
	Navi.add_child_to_current(hud)

	return hud

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

signal notification(notif)

var queued_notifs = []

func notif(text, opts = {}):
	Log.pr("notif: ", text)
	if text is Dictionary:
		opts.merge(text)
		text = opts.get("text", opts.get("msg"))
	if typeof(opts) == TYPE_STRING or not opts is Dictionary:
		text += str(opts)
		opts = {}
	opts["text"] = text
	if not "ttl" in opts:
		opts["ttl"] = 3.0
	notification.emit(opts)

var queued_notifs_dev = []

func dev_notif(msg, msg2=null, msg3=null, msg4=null, msg5=null, msg6=null, msg7=null):
	var msgs = [msg, msg2, msg3, msg4, msg5, msg6, msg7]
	msgs = msgs.filter(func(m): return m)
	msg = Log.to_printable(msgs)
	notification.emit({msg=msg, rich=true, ttl=5.0})
