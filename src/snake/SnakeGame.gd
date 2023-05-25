@tool
extends DinoGame

var song_name = DJZ.S.field_stars

func _ready():
	# TODO restore music
	# if not Engine.is_editor_hint():
	# 	DJZ.play_song(song_name)

	main_menu_scene = load("res://src/snake/menus/SnakeMainMenu.tscn")

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/snake")

func register():
	register_menus()

func should_spawn_player(_scene):
	return false

func start():
	current_level_idx = -1
	load_next_level()

func all_levels_complete():
	Hood.notif("Game complete!")
	DJZ.interrupt_song(song_name)
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
	Debug.prn("snake game loading next level")
	Debug.prn("current_level_idx: ", current_level_idx)
	if current_level_idx == null:
		current_level_idx = 0
	else:
		current_level_idx += 1

	if current_level_idx < levels.size():
		var lvl = levels[current_level_idx]
		Quest.current_level_label = lvl["label"]
		Debug.prn("Navi.nav_to: ", lvl["label"])
		Navi.nav_to(lvl["scene"])
	else:
		all_levels_complete()


func reload_current_level():
	Navi.nav_to(levels[current_level_idx]["scene"])
