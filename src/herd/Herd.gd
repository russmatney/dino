@tool
extends DinoGame

######################################################
# level menu

var next_level_menu_sfp = preload("res://src/herd/menus/NextLevelMenu.tscn")
var next_level_menu

func show_next_level_menu():
	next_level_menu.show()

######################################################
# dino game api

var player_scene = preload("res://src/herd/player/Player.tscn")

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/herd")

func should_spawn_player(scene):
	return not scene.scene_file_path.begins_with("res://src/herd/menus")

func register():
	next_level_menu = Navi.add_menu(next_level_menu_sfp)

######################################################
# level mgmt

var levels = [
	"res://src/herd/levels/LevelOne.tscn",
	"res://src/herd/levels/LevelTwo.tscn"
	]

var level_idx = 0
var level_complete = false

func start():
	level_idx = 0
	load_level(level_idx)

func load_next_level():
	level_idx += 1
	if len(levels) <= level_idx:
		Debug.err("level_idx too high, can't load next level")
		return
	load_level(level_idx)
	next_level_menu.hide()

func retry_level():
	if len(levels) <= level_idx:
		Debug.err("level_idx too high, can't retry level")
		return
	load_level(level_idx)

func load_level(idx):
	level_complete = false

	# support 'managed' game when using a 'proper' load (from a menu)
	Game.is_managed = true

	# restore player health
	if Game.player and is_instance_valid(Game.player):
		Hotel.check_in(Game.player, {health=Game.player.max_health})

	# load level
	Navi.nav_to(levels[idx])

func handle_level_complete():
	level_complete = true
	if level_idx == len(levels) - 1:
		# TODO proper congrats
		Navi.show_win_menu()
	else:
		show_next_level_menu()
