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
	{
		"label": "Gunner",
		"nav_to": "res://src/gunner/player/PlayerGym.tscn",
	},
	{
		"label": "Tower",
		"nav_to": "res://src/tower/menus/TowerMainMenu.tscn",
	},
]

export(PackedScene) var button_scene = preload("res://addons/navi/ui/MenuButton.tscn")

func _ready():
	for ms in menu_scenes:
		ms.merge({"button_scene": button_scene})
		add_menu_item(ms)

	if Engine.editor_hint:
		request_ready()
