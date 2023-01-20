tool
extends Node

var deving_tower = true

onready var tower_hud = preload("res://src/tower/hud/HUD.tscn")

func _ready():
	print("Tower autoload ready")

	if OS.has_feature("tower") or deving_tower:
		Navi.set_pause_menu("res://src/tower/menus/TowerPauseMenu.tscn")
		Navi.set_main_menu("res://src/tower/menus/TowerMainMenu.tscn")
		Hood.set_hud_scene(tower_hud)

func _unhandled_input(event):
	# consider making this a hold-for-two-seconds
	if deving_tower:
		if Trolley.is_event(event, "restart"):
			Hood.notif("Restarting Game")
			restart_game()

###########################################################################
# (re)start game

var default_game_path = "res://src/tower/maps/TowerClimb.tscn"

func restart_game():
	print("[TOWER] restarting game")
	Navi.resume() # ensure unpaused
	Respawner.reset_respawns()

	if Navi.current_scene.filename.match("*tower/maps*"):
		Navi.nav_to(Navi.current_scene.filename)
	else:
		Navi.nav_to(default_game_path)

	DJ.pause_menu_song() # ensure menu music not playing
