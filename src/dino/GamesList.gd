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
		label="Herd",
		fn=Game.load_main_menu.bind(Herd),
	},
	{
		label="Ghost House",
		fn=Game.load_main_menu.bind(Ghosts),
	},
	{
		label="Harvey",
		fn=Game.load_main_menu.bind(Harvey),
	},
	{
		label="Tower",
		fn=Game.load_main_menu.bind(Tower),
	},
	{
		label="Snake",
		fn=Game.load_main_menu.bind(SnakeGame),
	},
]

@export var button_scene: PackedScene = preload("res://addons/navi/ui/MenuButton.tscn")

func _ready():
	for ms in menu_scenes:
		ms.merge({button_scene=button_scene}, true)
		add_menu_item(ms)

	if Engine.is_editor_hint():
		request_ready()
