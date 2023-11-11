@tool
extends NaviButtonList

func load_next_level():
	var level_idx = HerdData.levels.find(Navi.current_scene_path())
	level_idx += 1
	if len(HerdData.levels) <= level_idx:
		Log.err("level_idx too high, can't load next level")
		return
	Navi.nav_to(HerdData.levels[level_idx])

func retry_level():
	var level_idx = HerdData.levels.find(Navi.current_scene_path())
	if len(HerdData.levels) <= level_idx:
		Log.err("level_idx too high, can't retry level")
		return
	Navi.nav_to(HerdData.levels[level_idx])

func no_more_levels():
	var level_idx = HerdData.levels.find(Navi.current_scene_path())
	return level_idx >= len(HerdData.levels) - 1

var buttons = [
	{
		label="Next Level",
		fn=load_next_level,
		hide_fn=no_more_levels
	},
	{
		label="Play Level Again",
		fn=retry_level,
		hide_fn=no_more_levels
	},
	{
		label="Restart Game",
		fn=Game.restart_game,
		hide_fn=func (): return not no_more_levels()
	},
	{
		label="Credits",
		fn=Navi.nav_to.bind("res://src/dino/DinoCredits.tscn"),
		hide_fn=func (): return not no_more_levels()
	},
	{
		label="Return to Main Menu",
		fn=func(): Navi.nav_to_main_menu(),
		hide_fn=func (): return not no_more_levels()
	},
	{
		label="Return to Dino Menu",
		fn=Navi.nav_to_main_menu,
		hide_fn=func(): return not (OS.has_feature("dino") or OS.has_feature("editor")),
	},
]

# default button scene
@export var button_scene: PackedScene = preload("res://addons/navi/ui/MenuButton.tscn")

func _ready():
	rebuild()

	if Engine.is_editor_hint():
		request_ready()


func rebuild():
	clear()
	for ms in buttons:
		ms.merge({button_scene=button_scene}, true)
		add_menu_item(ms)
