tool
extends NaviButtonList

var menu_scenes = [
	{
		"label": "Play",
		"nav_to": "res://src/ghosts/world/House.tscn",
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
