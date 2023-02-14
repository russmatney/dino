extends NaviButtonList


func return_to_main_menu():
	owner.hide()
	Navi.nav_to_main_menu()


func restart():
	owner.hide()
	Harvey.restart_game()

var button_defs = [
	{
		"label": "Restart",
		"fn": self.restart,
	},
	{
		"label": "Return to Main Menu",
		"fn": self.return_to_main_menu,
	},
]


func _ready():
	for def in button_defs:
		add_menu_item(def)

	if Engine.is_editor_hint():
		request_ready()
