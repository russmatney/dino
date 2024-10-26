@tool
extends Control

## reload button ######################################################################

var editor_interface
func _on_reload_plugin_button_pressed():
	if Engine.is_editor_hint():
		print("Reloading dj plugin ----------------------------------")
		editor_interface.set_plugin_enabled("dj", false)
		editor_interface.set_plugin_enabled("dj", true)
		editor_interface.set_main_screen_editor("DJTurnTable")
		print("Reloaded dj plugin -----------------------------------")
	else:
		print("DJ UI Reload Not impled outside of editor")

## ready ######################################################################

@onready var mute_all_btn = $%MuteAll
@onready var toggle_mute_music_btn = $%ToggleMuteMusic
@onready var toggle_mute_sound_btn = $%ToggleMuteSound

func _ready():
	mute_all_btn.pressed.connect(DJ.mute_all)
	toggle_mute_music_btn.pressed.connect(DJ.toggle_mute_music)
	toggle_mute_sound_btn.pressed.connect(DJ.toggle_mute_sound)

	DJ.mute_toggle.connect(update_mute_status)
	update_mute_status

func update_mute_status():
	mute_all_btn.disabled = DJ.muted_sound and DJ.muted_music

	if DJ.muted_sound:
		toggle_mute_sound_btn.text = "Unmute sound"
	else:
		toggle_mute_sound_btn.text = "Mute sound"
	if DJ.muted_music:
		toggle_mute_music_btn.text = "Unmute music"
	else:
		toggle_mute_music_btn.text = "Mute music"
