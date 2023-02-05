tool
extends Node

func _ready():
	print("SnakeGame ready")
	load_next_level()

func start_game():
	load_next_level()

func all_levels_complete():
	Hood.notif("Game complete!")
	print("TODO Load credits?")

var levels = [{
		"label": "Level One",
		"scene": preload("res://src/snake/levels/One.tscn"),
	}, {
		"label": "Level Two",
		"scene": preload("res://src/snake/levels/Two.tscn"),
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
		Navi.show_win_menu()


func reload_current_level():
	Navi.nav_to(levels[current_level_idx]["scene"])
