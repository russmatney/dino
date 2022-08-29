tool
extends NaviMenu

var menu_scenes = [
	{
		"label": "Machine Movement Demo",
		"nav_to": "res://test/unit/beehive/machine/MovementDemo.tscn",
	},
	{
		"label": "Navi Menu Test",
		"nav_to": "res://test/unit/navi/NaviMenuTest.tscn",
	},
	{
		"label": "Maze Game",
		"nav_to": "res://src/demos/Maze.tscn",
	},
	{
		"label": "Clawe Dashboard",
		"nav_to": "res://src/clawe/ClaweDashboard.tscn",
	},
	{
		"label": "Credits",
		"nav_to": "res://src/demos/DinoCredits.tscn",
	},
]


func _ready():
	for ms in menu_scenes:
		add_menu_item(ms)

	if Engine.editor_hint:
		request_ready()

	add_menu_item({"label": "I'm a disabled button"})
