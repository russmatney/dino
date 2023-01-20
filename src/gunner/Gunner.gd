extends Node

var deving_gunner = false

onready var gunner_hud = preload("res://src/gunner/hud/HUD.tscn")

func _ready():
	if OS.has_feature("gunner") or deving_gunner:
		Navi.set_pause_menu("res://src/gunner/menus/GunnerPauseMenu.tscn")
		Hood.set_hud_scene(gunner_hud)

func _unhandled_input(event):
	# consider making this a hold-for-two-seconds
	if deving_gunner:
		if Trolley.is_event(event, "restart"):
			Hood.notif("Restarting Game")
			restart_game()

###########################################################################
# (re)start game

var default_game_path = "res://src/gunner/player/PlayerGym.tscn"

func restart_game():
	Navi.resume() # ensure unpaused
	Respawner.reset_respawns()

	if Navi.current_scene.filename.match("*gunner*"):
		Navi.nav_to(Navi.current_scene.filename)
	else:
		Navi.nav_to(default_game_path)

