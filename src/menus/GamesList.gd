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
		"label": "Ghosts",
		"nav_to": "res://src/ghosts/world/World.tscn",
	},
]


func _ready():
	for ms in menu_scenes:
		add_menu_item(ms)

	if Engine.editor_hint:
		request_ready()
