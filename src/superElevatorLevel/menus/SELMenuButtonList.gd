@tool
extends NaviButtonList

var menu_scenes = [
	{
		label="Start Game",
		fn=Game.restart_game.bind(SuperElevatorLevel),
	},
]

# default button scene
@export var button_scene: PackedScene = preload("res://addons/navi/ui/MenuButton.tscn")

func _ready():
	for ms in menu_scenes:
		ms.merge({button_scene=button_scene}, true)
		add_menu_item(ms)

	if Engine.is_editor_hint():
		request_ready()

