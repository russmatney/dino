tool
extends Node

var deving_tower = true

onready var tower_hud = preload("res://src/tower/hud/HUD.tscn")


func _ready():
	if OS.has_feature("tower") or deving_tower:
		Navi.set_pause_menu("res://src/tower/menus/TowerPauseMenu.tscn")
		Navi.set_main_menu("res://src/tower/menus/TowerMainMenu.tscn")
		Hood.set_hud_scene(tower_hud)


func _unhandled_input(event):
	# consider making this a hold-for-two-seconds
	if deving_tower:
		if Trolley.is_event(event, "restart"):
			Hood.notif("Regenerating rooms")
			Navi.current_scene.regen_all_rooms()
			# Hood.notif("Restarting Game")
			# restart_game()


###########################################################################
# (re)start game

var default_game = preload("res://src/tower/maps/TowerClimb.tscn")

var levels = [
	"res://src/tower/maps/TowerClimb0.tscn",
	"res://src/tower/maps/TowerClimb1.tscn",
	"res://src/tower/maps/TowerClimb2.tscn",
	"res://src/tower/maps/TowerClimb3.tscn",
	"res://src/tower/maps/TowerClimb4.tscn",
	"res://src/tower/maps/TowerClimb5.tscn",
]


func restart_game(opts = {}):
	print("[TOWER] restarting game: ", opts)
	Navi.resume()  # ensure unpaused
	Respawner.reset_respawns()

	var level_path = opts.get("level", levels[0])
	Navi.nav_to(level_path)

	DJ.pause_menu_song()  # ensure menu music not playing


func level_complete():
	print("[TOWER] level complete")

	var curr = Navi.current_scene
	var idx = levels.find(curr.filename)

	if idx + 1 >= levels.size():
		Navi.show_win_menu()
	else:
		restart_game({"level": levels[idx + 1]})


###########################################################################
# player

var player_scene = preload("res://src/gunner/player/Player.tscn")
var player
signal player_spawned(player)

var player_default_opts = {"has_jetpack": true}


func spawn_player(pos):
	player = player_scene.instance()
	for k in player_default_opts.keys():
		player[k] = player_default_opts[k]
	player.position = pos
	player.connect("dead", self, "show_dead")
	Navi.add_child_to_current(player)
	emit_signal("player_spawned", player)
	GunnerSounds.play_sound("player_spawn")
	return player


func show_dead():
	print("[TOWER] player dead")
	Navi.show_death_menu()


###########################################################################
# enemy

var enemy_robot_scene = preload("res://src/gunner/enemies/EnemyRobot.tscn")


func spawn_enemy(pos):
	var enemy = enemy_robot_scene.instance()
	enemy.position = pos
	Navi.add_child_to_current(enemy)
	GunnerSounds.play_sound("enemy_spawn")
	return enemy
