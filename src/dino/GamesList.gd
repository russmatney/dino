@tool
extends NaviButtonList

# TODO map Games.games with something like menu_link
# TODO create and include icons for each game
var menu_scenes = [
	{
		label="Hatbot",
		nav_to="res://src/hatbot/menus/MainMenu.tscn",
	},
	{
		label="Super Elevator Level",
		nav_to="res://src/superElevatorLevel/menus/MainMenu.tscn",
	},
	{
		label="The Mountain",
		nav_to="res://src/mountain/menus/MainMenu.tscn",
	},
	{
		label="Herd",
		nav_to="res://src/herd/menus/MainMenu.tscn",
	},
	{
		label="Dungeon Crawler",
		nav_to="res://src/dungeonCrawler/zones/TwoGeon.tscn",
	},
	{
		label="Runner",
		nav_to="res://src/runner/park/ThePark.tscn",
	},
	{
		label="Ghost House",
		nav_to="res://src/ghosts/GhostsMenu.tscn",
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
		nav_to="res://src/gunner/player/PlayerGym.tscn",
	},
	{
		label="Tower",
		nav_to="res://src/tower/menus/TowerMainMenu.tscn",
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
