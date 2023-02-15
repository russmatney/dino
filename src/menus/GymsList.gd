@tool
extends NaviButtonList

# TODO parse paths to scenes with 'Gym' or 'Demo' into a menu_scenes list

var menu_scenes = [
	{
		"label": "Maze",
		"nav_to": "res://src/dungeonCrawler/rooms/Maze.tscn",
	},
]


func _ready():
	for ms in menu_scenes:
		add_menu_item(ms)

	if Engine.is_editor_hint():
		request_ready()
