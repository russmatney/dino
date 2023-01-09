tool
extends NaviButtonList

var menu_scenes = [
	{
		"label": "Dungeon Crawler",
		"nav_to": "res://src/dungeonCrawler/rooms/OneGeon.tscn",
	},
	{
		"label": "Runner",
		"nav_to": "res://src/runner/park/ThePark.tscn",
	},
	{
		"label": "Ghost House",
		"nav_to": "res://src/ghosts/GhostsMenu.tscn",
	},
	{
		"label": "Pluggs",
		"nav_to": "res://src/pluggs/factory/FactoryFloor.tscn",
	},
	{
		"label": "Harvey",
		"nav_to": "res://src/harvey/menus/HarveyMenu.tscn",
	},
]


func _ready():
	for ms in menu_scenes:
		add_menu_item(ms)

	if Engine.editor_hint:
		request_ready()
