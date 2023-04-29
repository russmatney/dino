@tool
extends NaviButtonList

var menu_scenes = [
	{"label": "Play", "fn": Harvey.restart_game},
	{
		"label": "Credits",
		"nav_to": "res://src/dino/DinoCredits.tscn",
	},
]


func _ready():
	for ms in menu_scenes:
		add_menu_item(ms)

	if Engine.is_editor_hint():
		request_ready()
