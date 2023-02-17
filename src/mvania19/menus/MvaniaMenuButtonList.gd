@tool
extends NaviButtonList


var button_defs = [
	{
		"label": "Start Game",
		"fn": MvaniaGame.restart_game,
	},
]


func _ready():
	for def in button_defs:
		add_menu_item(def)

	if Engine.is_editor_hint():
		request_ready()
