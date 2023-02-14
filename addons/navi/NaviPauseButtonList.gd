@tool
extends NaviButtonList


func return_to_main_menu():
	print("return to main clicked")
	Navi.nav_to_main_menu()
	Navi.resume()

func resume():
	print("resume clicked")
	hide()
	# NOTE resume also `hides` the popup, if it's known
	# but we include the `hide()` here in case some consumer has opt-ed out
	Navi.resume()

var button_defs = [
	{
		"label": "Return to Main Menu",
		"fn": self.return_to_main_menu,
	},
	{
		"label": "Resume",
		"fn": self.resume,
	},
]


func _ready():
	for def in button_defs:
		add_menu_item(def)

	if Engine.is_editor_hint():
		request_ready()
