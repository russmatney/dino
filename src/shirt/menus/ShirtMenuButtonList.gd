@tool
extends NaviButtonList


var button_defs = [
	# {
	# 	"label": "Start Game",
	# 	"fn": Game.restart_game,
	# },
	{
		label="Return to Dino Menu",
		fn=Navi.nav_to_main_menu,
		hide_fn=func(): return not (OS.has_feature("dino") or OS.has_feature("editor")),
	},
	{
		label="Credits",
		nav_to="res://src/dino/menus/DinoCredits.tscn",
	},
]


func _ready():
	for def in button_defs:
		add_menu_item(def)

	if Engine.is_editor_hint():
		request_ready()
