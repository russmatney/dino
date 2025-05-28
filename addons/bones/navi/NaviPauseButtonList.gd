@tool
extends NaviButtonList

var button_defs := [
	{
		label="Resume",
		fn=Navi.resume,
	},
	{
		label="Main Menu",
		fn=Navi.nav_to_main_menu,
	},
	{
		label="Quit Game",
		fn=func() -> void: get_tree().quit(),
	},
]

func _ready() -> void:
	for def: Dictionary in button_defs:
		add_menu_item(def)

	if Engine.is_editor_hint():
		request_ready()
