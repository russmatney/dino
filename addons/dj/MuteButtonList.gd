@tool
extends NaviButtonList

var button_defs = [
	{
		label="Mute Music",
		hide_fn=func(): return DJ.muted_music,
		fn=func():
		DJ.toggle_mute_music(true)
		reload(),
	},
	{
		label="Unmute Music",
		hide_fn=func(): return not DJ.muted_music,
		fn=func():
		DJ.toggle_mute_music(false)
		reload(),
	},
	{
		label="Mute Sound",
		hide_fn=func(): return DJ.muted_sound,
		fn=func():
		DJ.toggle_mute_sound(true)
		reload(),
	},
	{
		label="Unmute Sound",
		hide_fn=func(): return not DJ.muted_sound,
		fn=func():
		DJ.toggle_mute_sound(false)
		reload(),
	},
	{
		label="Unmute All",
		hide_fn=func(): return not DJ.muted_sound or not DJ.muted_music,
		fn=func():
		DJ.mute_all(false)
		reload(),
	},
	{
		label="Mute All",
		hide_fn=func(): return DJ.muted_sound and DJ.muted_music,
		fn=func():
		DJ.mute_all(true)
		reload(),
	},
]


func _ready():
	reload()

	if Engine.is_editor_hint():
		request_ready()

func reload():
	set_menu_items(button_defs)
