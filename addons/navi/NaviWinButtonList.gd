@tool
extends NaviButtonList

var button_defs = [
	{
		"label": "Credits",
		"nav_to": "res://src/dino/DinoCredits.tscn",
	},
	{
		"label": "Return to Main Menu",
		"fn": Navi.nav_to_main_menu,
	},
]

func _ready():
	for def in button_defs:
		add_menu_item(def)

	if Engine.is_editor_hint():
		request_ready()
