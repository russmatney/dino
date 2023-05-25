@tool
extends NaviButtonList

# TODO map Games.games with something like menu_link
# TODO create and include icons for each game
var menu_scenes = [
	{
		label="HatBot",
		fn=Game.load_main_menu.bind(HatBot),
	},
	{
		label="Super Elevator Level",
		fn=Game.load_main_menu.bind(SuperElevatorLevel),
	},
	{
		label="The Mountain",
		fn=Game.load_main_menu.bind(Mountain),
	},
	{
		label="Herd",
		fn=Game.load_main_menu.bind(Herd),
	},
	{
		label="Dungeon Crawler",
		fn=Game.restart_game.bind(DungeonCrawler),
	},
	{
		label="Runner",
		nav_to="res://src/runner/park/ThePark.tscn",
	},
	{
		label="Ghost House",
		fn=Game.load_main_menu.bind(Ghosts),
	},
	{
		label="Pluggs",
		nav_to="res://src/pluggs/factory/FactoryFloor.tscn",
	},
	{
		label="Harvey",
		nav_to="res://src/harvey/menus/HarveyMenu.tscn",
	},
	{
		label="Gunner",
		fn=Game.restart_game.bind(Gunner),
	},
	{
		label="Tower",
		fn=Game.load_main_menu.bind(Tower),
	},
	{
		label="Snake",
		nav_to="res://src/snake/menus/SnakeMainMenu.tscn",
	},
	{
		label="DemoLand",
		fn=Game.restart_game.bind(DemoLand),
	},
]

@export var button_scene: PackedScene = preload("res://addons/navi/ui/MenuButton.tscn")

func _ready():
	for ms in menu_scenes:
		ms.merge({button_scene=button_scene}, true)
		add_menu_item(ms)

	if Engine.is_editor_hint():
		request_ready()
