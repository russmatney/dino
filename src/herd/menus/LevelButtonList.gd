@tool
extends NaviButtonList

var buttons = [
	{
		label="Next Level",
		fn=Herd.load_next_level,
		hide_fn=Herd.no_more_levels
	},
	{
		label="Play Level Again",
		fn=Herd.retry_level,
		hide_fn=Herd.no_more_levels
	},
	{
		label="Restart Game",
		fn=Game.restart_game.bind(Herd),
		hide_fn=func (): return not Herd.no_more_levels()
	},
	{
		label="Credits",
		fn=func():
		Herd.next_level_menu.hide()
		Navi.nav_to("res://src/dino/DinoCredits.tscn"),
		hide_fn=func (): return not Herd.no_more_levels()
	},
	{
		label="Return to Main Menu",
		fn=func():
		Herd.next_level_menu.hide()
		Navi.nav_to_main_menu(),
		hide_fn=func (): return not Herd.no_more_levels()
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
