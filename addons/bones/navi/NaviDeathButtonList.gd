@tool
extends NaviButtonList

var button_defs := [
	{
		label="Main Menu",
		fn=Navi.nav_to_main_menu,
	},
]


func _ready() -> void:
	for def: Dictionary in button_defs:
		add_menu_item(def)

	if Engine.is_editor_hint():
		request_ready()
