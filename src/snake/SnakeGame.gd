@tool
extends Node

var song_name = "field-stars"

func _ready():
	print("SnakeGame ready")
	# TODO restore music
	# if not Engine.is_editor_hint():
	# 	SnakeSounds.play_song(song_name)

	if OS.has_feature("snake"):
		Navi.set_main_menu("res://src/snake/menus/SnakeMainMenu.tscn")

func start_game():
	current_level_idx = -1
	load_next_level()

func all_levels_complete():
	Hood.notif("Game complete!")
	SnakeSounds.interrupt_song(song_name)
	Navi.show_win_menu()

var levels = [{
		"label": "Level One",
		"scene": preload("res://src/snake/levels/One.tscn"),
	}, {
		"label": "Level Two",
		"scene": preload("res://src/snake/levels/Two.tscn"),
	}, {
		"label": "Level Three",
		"scene": preload("res://src/snake/levels/Three.tscn"),
	}]

var current_level_idx

func load_next_level():
	print("snake game loading next level")
	print("current_level_idx: ", current_level_idx)
	if current_level_idx == null:
		current_level_idx = 0
	else:
		current_level_idx += 1

	if current_level_idx < levels.size():
		var lvl = levels[current_level_idx]
		Quest.current_level_label = lvl["label"]
		print("Navi.nav_to: ", lvl["label"])
		Navi.nav_to(lvl["scene"])
	else:
		all_levels_complete()


func reload_current_level():
	Navi.nav_to(levels[current_level_idx]["scene"])
