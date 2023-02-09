@tool
extends NaviButtonList

var menu_scenes = [
	{
		"label": "Play",
		"obj": SnakeGame,
		"method": "start_game",
	},
	{
		"label": "Credits",
		"nav_to": "res://src/credits/DinoCredits.tscn",
	},
]


func _ready():
	for ms in menu_scenes:
		add_menu_item(ms)

	if Engine.editor_hint:
		request_ready()
