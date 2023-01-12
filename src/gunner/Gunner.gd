extends Node

var deving_gunner = true

func _ready():
	if OS.has_feature("gunner") or deving_gunner:
		Navi.set_pause_menu("res://src/gunner/menus/GunnerPauseMenu.tscn")

	setup_sounds()

func _unhandled_input(event):
	# consider making this a hold-for-two-seconds
	if deving_gunner:
		if Trolley.is_event(event, "restart"):
			notif("Restarting Game")
			restart_game()
		elif Trolley.is_event(event, "respawns"):
			notif("Respawning Targets")
			respawn_missing()

###########################################################################
# (re)start game

var default_game_path = "res://src/gunner/player/PlayerGym.tscn"

func restart_game():
	Navi.resume() # ensure unpaused
	reset_respawns()

	if Navi.current_scene.filename.match("gunner"):
		Navi.nav_to(Navi.current_scene.filename)
	else:
		Navi.nav_to(default_game_path)

###########################################################################
# hud

onready var hud_scene = preload("res://src/gunner/hud/HUD.tscn")
var hud

func ensure_hud():
	if hud and is_instance_valid(hud):
		print("[Gunner] HUD exists, nothing doing.")
		return

	hud = hud_scene.instance()
	call_deferred("add_child", hud)

###########################################################################
# notifs

signal notification(text)

func notif(text, ttl=5):
	print("[Gunner] notif: ", text)
	emit_signal("notification", {"msg": text, "ttl": ttl})

###########################################################################
# respawns

var respawns = []
signal respawn(node)

func register_respawn(node):
	if node.filename:
		respawns.append({
			"filename": node.filename,
			"position": node.get_global_position(),
			"node": node
			})

func reset_respawns():
	respawns = []

func respawn_all():
	for r in respawns:
		var ins = load(r["filename"]).instance()
		# ins.position = r["position"]
		Navi.current_scene.call_deferred("add_child", ins)

func respawn_missing():
	var to_remove = []
	for r in respawns:
		if not is_instance_valid(r["node"]):
			to_remove.append(r)
			var ins = load(r["filename"]).instance()
			ins.position = r["position"]
			Navi.current_scene.call_deferred("add_child", ins)
			emit_signal("respawn", ins)

	respawns = Util.remove_matching(respawns, to_remove)


###########################################################################
# sounds

onready var sounds = {
	"fire":
	[
		preload("res://assets/sounds/laser1.sfxr"),
		preload("res://assets/sounds/laser2.sfxr"),
	],
	"jump":
	[
		preload("res://assets/sounds/jump1.sfxr"),
		preload("res://assets/sounds/jump2.sfxr"),
		preload("res://assets/sounds/jump3.sfxr"),
	],
	"step":
	[
		preload("res://assets/sounds/step1.sfxr"),
		preload("res://assets/sounds/step2.sfxr"),
		preload("res://assets/sounds/step3.sfxr"),
	],
	"land":
	[
		preload("res://assets/sounds/step1.sfxr"),
		preload("res://assets/sounds/step2.sfxr"),
		preload("res://assets/sounds/step3.sfxr"),
	],
	"bullet_pop":
	[
		preload("res://assets/sounds/small_explosion.sfxr"),
	],
	"target_kill":
	[
		preload("res://assets/sounds/coin1.sfxr"),
		preload("res://assets/sounds/coin2.sfxr"),
		preload("res://assets/sounds/coin3.sfxr"),
	]
}
var sound_map
onready var laser_stream = preload("res://assets/harvey/sounds/slime_001.ogg")


func setup_sounds():
	sound_map = DJ.setup_sound_map(sounds)


func play_sound(name):
	if name in sound_map:
		var s = sound_map[name]
		DJ.play_sound_rand(s, {"vary": 0.3})
	else:
		print("[WARN]: no sound for name", name)
