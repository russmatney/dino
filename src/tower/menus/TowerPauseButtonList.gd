extends NaviButtonList

func restart():
	owner.hide()
	Tower.restart_game()

var button_defs = [
	{
		"label": "Resume",
		"fn": Navi.resume,
	},
	{
		"label": "Restart",
		"fn": self.restart,
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
