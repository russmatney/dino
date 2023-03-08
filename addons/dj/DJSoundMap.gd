@tool
class_name DJSoundMap
extends Node

func snds():
	if "sounds" in self:
		return self["sounds"]
	else:
		Debug.warn("no sounds configured in sound map:", name)
		return {}
var _sound_map

func _ready():
	var s = snds()
	_sound_map = DJ.setup_sound_map(s)

func play_sound(nm):
	DJ.play_sound(_sound_map, nm)

func interrupt_sound(nm):
	DJ.interrupt_sound(_sound_map, nm)

func play_song(nm):
	DJ.play_song(_sound_map, nm)

func interrupt_song(nm):
	DJ.interrupt_song(_sound_map, nm)
