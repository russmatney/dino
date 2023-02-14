@tool
extends NaviButtonList



func return_to_main():
	Navi.nav_to_main_menu()
	Navi.hide_win_menu()

func restart_game():
	SnakeGame.start_game()
	Navi.hide_win_menu()

var button_defs = [
	{
		"label": "Return to Main Menu",
		"fn": self.return_to_main,
	},
	# TODO general 'restart game' and menu-action registry
	# this should be overwritable, not snake specific within Navi
	{
		"label": "Restart Snake Game",
		"fn": self.restart_game,
	},
	{
		"label": "Credits",
		"nav_to": "res://src/credits/DinoCredits.tscn",
	},
]


func _ready():
	for def in button_defs:
		add_menu_item(def)

	if Engine.is_editor_hint():
		request_ready()
