@tool
extends DinoGame

func _ready():
	pause_menu_scene = load("res://src/tower/menus/TowerPauseMenu.tscn")
	main_menu_scene = load("res://src/tower/menus/TowerMainMenu.tscn")


## register #########################################################################

func register():
	register_menus()

## start game #########################################################################

var levels = [
	"res://src/tower/maps/TowerClimb1.tscn",
	"res://src/tower/maps/TowerClimb2.tscn",
	"res://src/tower/maps/TowerClimb3.tscn",
	"res://src/tower/maps/TowerClimb4.tscn",
	"res://src/tower/maps/TowerClimb5.tscn",
]

func start(_opts={}):
	Respawner.reset_respawns()
	var level_path = levels[0]
	Navi.nav_to(level_path)

func level_complete():
	Debug.pr("[TOWER] level complete")

	var idx = levels.find(Navi.current_scene.scene_file_path)

	if idx + 1 >= levels.size():
		Navi.show_win_menu()
	else:
		Respawner.reset_respawns()
		var level_path = levels[idx + 1]
		Navi.nav_to(level_path)


## player #########################################################################

var player_scene = preload("res://src/gunner/player/Player.tscn")

var player_default_opts = {"has_jetpack": true}


func on_player_spawned(player):
	for k in player_default_opts.keys():
		player[k] = player_default_opts[k]

	player.died.connect(Navi.show_death_menu)
	DJZ.play(DJZ.S.player_spawn)


## enemy ##########################################################################

var enemy_robot_scene = preload("res://src/gunner/enemies/EnemyRobot.tscn")


func spawn_enemy(pos):
	var enemy = enemy_robot_scene.instantiate()
	enemy.position = pos
	Navi.add_child_to_current(enemy)
	DJZ.play(DJZ.S.enemy_spawn)
	return enemy
