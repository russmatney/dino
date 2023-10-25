extends NaviButtonList

var button_defs = [
	{
		label="Resume",
		fn=Navi.resume,
	},
	{
		label="Restart",
		fn=Game.restart_game,
	},
	{
		label="Tower Jet Menu",
		fn=Game.load_main_menu,
	},
	{
		label="Dino Menu",
		fn=Navi.nav_to_main_menu,
		hide_fn=func(): return not (OS.has_feature("dino") or OS.has_feature("editor")),
	},
	{
		label="Quit Game",
		fn=func(): get_tree().quit(),
	},
]


func _ready():
	for def in button_defs:
		add_menu_item(def)

	if Engine.is_editor_hint():
		request_ready()
