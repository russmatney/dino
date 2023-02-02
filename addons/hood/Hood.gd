extends Node

###########################################################################
# config

onready var hud_scene = preload("res://src/tower/hud/HUD.tscn")


func set_hud_scene(preloaded_scene):
	print("[HOOD] Overriding fallback HUD scene: ", preloaded_scene)
	hud_scene = preloaded_scene


###########################################################################
# ensure hud

var hud


func ensure_hud(hud_preload=null):
	if hud and is_instance_valid(hud):
		print("[HOOD] HUD exists, nothing doing.")
		return

	if not hud_preload:
		hud_preload = hud_scene

	hud = hud_preload.instance()
	hud.connect("ready", self, "_on_hud_ready")
	# make sure hud is included in usual scene lifecycle/clean up
	Navi.add_child_to_current(hud)


signal hud_ready


func _on_hud_ready():
	emit_signal("hud_ready")


###########################################################################
# notifs

signal notification(text)


func notif(text, ttl = 5):
	print("[HOOD] notif: ", text)
	if not hud:
		# TODO queue and fire after hud is ready
		print("no hud yet")
	emit_signal("notification", {"msg": text, "ttl": ttl})
