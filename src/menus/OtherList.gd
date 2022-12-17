tool
extends NaviButtonList

var menu_scenes = [
	{
		"label": "Navi Menu Test",
		"nav_to": "res://test/unit/navi/NaviButtonListTest.tscn",
	},
	{
		"label": "Clawe Dashboard",
		"nav_to": "res://src/clawe/ClaweDashboard.tscn",
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
