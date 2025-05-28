@tool
class_name DJSoundMap
extends Node

func snds() -> Dictionary:
	if "sounds" in self:
		return self["sounds"]
	if "music" in self:
		return self["music"]
	else:
		Log.warn("no sounds configured in sound map:", name)
		return {}

var _sound_map: Dictionary

func _ready() -> void:
	var s := snds()
	_sound_map = DJ.setup_sound_map(s)

func play(nm: Variant, opts:={}) -> void:
	DJ.play_sound(_sound_map, nm, opts)

func interrupt(nm: Variant) -> void:
	DJ.interrupt_sound(_sound_map, nm)
