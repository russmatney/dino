@tool
extends NaviButtonList

func return_to_main_menu():
	print("death return to main clicked")
	Navi.hide_death_menu()
	Navi.nav_to_main_menu()

var button_defs = [
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
