extends "res://addons/gd-plug/plug.gd"

func _plugging():
	plug("MikeSchulze/gdUnit4", {include=["addons/gdUnit4"]})
	plug("bitbrain/pandora", {include=["addons/pandora"]})
	plug("nathanhoad/godot_input_helper", {include=["addons/input_helper"]})
	plug("nathanhoad/godot_sound_manager", {include=["addons/sound_manager"]})
	plug("nathanhoad/godot_dialogue_manager", {include=["addons/dialogue_manager"]})
	plug("timothyqiu/gdfxr")
	plug("viniciusgerevini/godot-aseprite-wizard", {include=["addons/AsepriteWizard"]})
	plug("russmatney/bones", {include=["addons/bones"]})
	plug("russmatney/log.gd", {include=["addons/log"]})
	plug("KoBeWi/Metroidvania-System", {include=["addons/MetroidvaniaSystem"]})
	plug("KoBeWi/Godot-Custom-Runner", {include=["addons/CustomRunner"], exclude=["ExampleProject"]})
	plug("SirLich/asset-explorer", {include=["addons/gd_explorer"]})
	plug("ramokz/phantom-camera", {include=["addons/phantom_camera"]})
	plug("SimonGigant/godot-text_effects_4.0")
