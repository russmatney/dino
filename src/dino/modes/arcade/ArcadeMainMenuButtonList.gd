@tool
extends NaviButtonList

var menu_scenes = [
	{
		label="Start!",
		fn=Dino.start.bind(Pandora.get_entity(ModeIds.ARCADE)),
	},
	{
		label="Back to Dino Menu",
		fn=Navi.nav_to_main_menu,
		hide_fn=func(): return not (OS.has_feature("dino") or OS.has_feature("editor")),
	},
]

# default button scene
@export var button_scene: PackedScene = preload("res://addons/bones/navi/ui/MenuButton.tscn")

func _ready():
	for ms in menu_scenes:
		ms.merge({button_scene=button_scene}, true)
		add_menu_item(ms)

	if Engine.is_editor_hint():
		request_ready()
