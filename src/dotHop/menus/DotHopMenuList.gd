@tool
extends NaviButtonList

var button_defs = [
	{
		label="Start",
		fn=Game.restart_game.bind(DotHop),
	},
	# TODO select theme
	# TODO continue saved game
	# TODO level select
	{
		label="Dino Menu",
		fn=Navi.nav_to_main_menu,
		hide_fn=func(): return not (OS.has_feature("dino") or OS.has_feature("editor")),
	},
]


func _ready():
	for def in button_defs:
		add_menu_item(def)

	if Engine.is_editor_hint():
		request_ready()