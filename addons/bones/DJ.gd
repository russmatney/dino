@tool
extends Node

## vars ######################################################################

var muted_sound := false
var muted_music := false
signal mute_toggle

## ready ######################################################################

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS

## play sound ######################################################################

func play_sound_opts(sounds: Array, opts := {}) -> void:
	var vary: float = opts.get("vary", 0.0)
	var scale_range: float = opts.get("scale_range", 0)
	var scale_note: float = opts.get("scale_note", 0)

	if sounds:
		var i := randi() % sounds.size()
		var s: AudioStream = sounds[i]
		if not is_instance_valid(s):
			return
		var pitch := 1.0
		if scale_range > 0.0 and scale_note != 0.0:
			var note: float = lerp(0.0, 1.0, scale_note/scale_range)
			pitch = note
		elif vary > 0.0:
			pitch = 1 - (randf() * vary)

		if opts.get("interrupt"):
			SoundManager.stop_sound(s)

		if not Engine.is_editor_hint():
			SoundManager.play_sound_with_pitch(s, pitch)

## sound map setup ####################################################

func setup_sound(sound: Variant, _opts := {}) -> AudioStream:
	var s_str: String
	if sound is String:
		s_str = sound
		sound = load(s_str)
	if not sound:
		Log.warn("Could not load sound", s_str)
		return
	return sound

func setup_sound_map(sound_map: Dictionary) -> Dictionary:
	var playables := {}
	for k: Variant in sound_map.keys():
		playables[k] = []
		if not sound_map[k] is Array:
			sound_map[k] = [sound_map[k]]
		for s: Variant in sound_map[k]:
			var sound: Variant = s
			var opts := {}
			if typeof(s) == TYPE_ARRAY:
				sound = s[0]
				opts = s[1]
			var playable := setup_sound(sound, opts)
			if playable:
				@warning_ignore("unsafe_method_access")
				playables[k].append(playable)
	return playables

func play_sound(sound_map: Dictionary, nm: Variant, opts := {}) -> void:
	if muted_sound:
		# Log.warn("Cannot play sound, sounds are muted")
		return
	if nm in sound_map:
		var sounds : Array = sound_map[nm]
		opts.merge({"vary": 0.4})
		play_sound_opts(sounds, opts)
	else:
		Log.warn("no sound for name", nm)

func interrupt_sound(sound_map: Dictionary, nm: Variant) -> Variant:
	if nm in sound_map:
		var to_return: AudioStream
		for s: AudioStream in sound_map[nm]:
			# stop any of these that are playing
			SoundManager.stop_sound(s)
			if to_return == null:
				to_return = s
		# return the first sound from the map
		return to_return
	else:
		Log.warn("no sound for name", name)
	return

## mute ######################################################################

func mute_all(should_mute:=true) -> void:
	toggle_mute_music(should_mute)
	toggle_mute_sound(should_mute)

var music_volume: float
func toggle_mute_music(should_mute: Variant = null) -> void:
	if should_mute == null:
		muted_music = not muted_music
	else:
		muted_music = should_mute

	if muted_music:
		if music_volume != 0:
			music_volume = SoundManager.get_music_volume()
		SoundManager.set_music_volume(0.0)
	else:
		if music_volume != 0:
			SoundManager.set_music_volume(music_volume)
		else:
			SoundManager.set_music_volume(0.5)

	mute_toggle.emit()

func toggle_mute_sound(should_mute: Variant = null) -> void:
	if should_mute == null:
		muted_sound = not muted_sound
	else:
		muted_sound = should_mute
	mute_toggle.emit()
