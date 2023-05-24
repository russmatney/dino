@tool
extends NaviButtonList

var menu_scenes = [
	{"label": "Play", "fn": Harvey.restart_game},
	{
		"label": "Credits",
		"nav_to": "res://src/dino/DinoCredits.tscn",
	},
	{
		label="Dino Menu",
		fn=Navi.nav_to_main_menu,
		hide_fn=func(): return not (OS.has_feature("dino") or OS.has_feature("editor")),
	},
]


func _ready():
	for ms in menu_scenes:
		add_menu_item(ms)

	if Engine.is_editor_hint():
		request_ready()
