@tool
extends NaviButtonList

# TODO parse paths to scenes with 'Gym' or 'Demo' into a menu_scenes list

var menu_scenes = [
	{
		label="Maze",
		nav_to="res://src/dungeonCrawler/zones/Maze.tscn",
	},
	{
		label="Mvania Demo Map",
		nav_to="res://src/demoland/DemoMap.tscn",
	},
	{
		label="Mvania DemoLand",
		nav_to="res://src/demoland/zones/area01/Area01.tscn",
	},
]


func _ready():
	for ms in menu_scenes:
		add_menu_item(ms)

	if Engine.is_editor_hint():
		request_ready()
