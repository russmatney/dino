@tool
extends DinoGame

func _ready():
	main_menu_scene = load("res://src/herd/menus/MainMenu.tscn")

	var next_level_menu_scene = load("res://src/herd/menus/NextLevelMenu.tscn")
	next_level_menu = Navi.add_menu(next_level_menu_scene)

	icon_texture = load("res://assets/sprites/Herd_icon_sheet.png")

######################################################
# level menu

var next_level_menu

######################################################
# dino game api

var player_scene = preload("res://src/herd/player/Player.tscn")

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/herd")

func should_spawn_player(scene):
	return not scene.scene_file_path.begins_with("res://src/herd/menus")

func register():
	register_menus()

######################################################
# level mgmt

var levels = [
	"res://src/herd/levels/LevelOne.tscn",
	"res://src/herd/levels/LevelThrowSheep.tscn",
	"res://src/herd/levels/LevelPlayerJump.tscn",
	"res://src/herd/levels/LevelTwo.tscn",
	"res://src/herd/levels/LevelThree.tscn"
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
	Navi.hide_menus()

func handle_level_complete():
	if level_idx == len(levels) - 1:
		next_level_menu.update_hero_text("You Win!")
	else:
		next_level_menu.update_hero_text("Level Complete!")
	next_level_menu.update_sheep_saved()
	next_level_menu.update_buttons()
	Navi.show_menu(next_level_menu)

func no_more_levels():
	return level_idx >= len(levels) - 1
