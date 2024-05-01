@tool
class_name DJSoundMap
extends Node

func snds():
	if "sounds" in self:
		return self["sounds"]
	if "music" in self:
		return self["music"]
	else:
		Log.warn("no sounds configured in sound map:", name)
		return {}
var _sound_map

func _ready():
	var s = snds()
	_sound_map = DJ.setup_sound_map(s)

func play(nm, opts={}):
	DJ.play_sound(_sound_map, nm, opts)

func interrupt(nm):
	DJ.interrupt_sound(_sound_map, nm)
