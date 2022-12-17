tool
extends NaviButtonList

# TODO parse paths to scenes with 'Gym' or 'Demo' into a menu_scenes list

var menu_scenes = [
	{
		"label": "Machine Movement Demo",
		"nav_to": "res://test/unit/beehive/machine/MovementDemo.tscn",
	},
	{
		"label": "Maze",
		"nav_to": "res://src/dungeonCrawler/rooms/Maze.tscn",
	},
	{
		"label": "Room",
		"nav_to": "res://src/dungeonCrawler/rooms/Room.tscn",
	},
]


func _ready():
	for ms in menu_scenes:
		add_menu_item(ms)

	if Engine.editor_hint:
		request_ready()
