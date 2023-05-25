@tool
extends NaviButtonList

# TODO parse paths to scenes with 'Gym' or 'Demo' into a menu_scenes list

var menu_scenes = [
	{
		label="Runner",
		nav_to="res://src/runner/park/ThePark.tscn",
	},
	{
		label="DemoLand",
		fn=Game.restart_game.bind(DemoLand),
	},
	{
		label="Gunner",
		fn=Game.restart_game.bind(Gunner),
	},
	{
		label="Pluggs",
		nav_to="res://src/pluggs/factory/FactoryFloor.tscn",
	},
	{
		label="The Mountain",
		fn=Game.load_main_menu.bind(Mountain),
	},
	{
		label="Dungeon Crawler",
		fn=Game.restart_game.bind(DungeonCrawler),
	},
]


func _ready():
	for ms in menu_scenes:
		add_menu_item(ms)

	if Engine.is_editor_hint():
		request_ready()
