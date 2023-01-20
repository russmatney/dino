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

func ensure_hud():
	if hud and is_instance_valid(hud):
		print("[HOOD] HUD exists, nothing doing.")
		return

	hud = hud_scene.instance()
	# make sure hud is included in usual scene lifecycle/clean up
	Navi.add_child_to_current(hud)

###########################################################################
# notifs

signal notification(text)

func notif(text, ttl=5):
	print("[HOOD] notif: ", text)
	emit_signal("notification", {"msg": text, "ttl": ttl})
