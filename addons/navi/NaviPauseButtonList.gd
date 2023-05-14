@tool
extends NaviButtonList

var button_defs = [
	{
		label="Return to Main Menu",
		fn=Game.load_main_menu,
	},
	{
		label="Resume",
		fn=Navi.resume,
	},
]


func _ready():
	for def in button_defs:
		add_menu_item(def)

	if Engine.is_editor_hint():
		request_ready()
