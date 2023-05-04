@tool
extends NaviButtonList

var menu_scenes = [
	{
		"label": "Next Level",
		"fn": Herd.load_next_level
	},
	{
		"label": "Play Level Again",
		"fn": Herd.retry_level
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

