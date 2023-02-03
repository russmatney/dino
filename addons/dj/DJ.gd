tool
extends Node

onready var menu_song = preload("res://addons/dj/assets/songs/Late Night Radio.mp3")
var menu_song_player
var playback_pos


func _ready():
	# so we can play music while paused
	pause_mode = PAUSE_MODE_PROCESS

	if menu_song:
		print("[DJ]: Menu song configured")

	menu_song_player = setup_sound(menu_song, {"is_sound": false})


# TODO support a passed song as well
# TODO may need to handle pausing the current song before overwriting here
func resume_menu_song(song = null):
	if song and menu_song != song:
		menu_song = song
		menu_song_player.set_stream(menu_song)

	if not Engine.editor_hint:
		if playback_pos:
			menu_song_player.play(playback_pos)
		else:
			menu_song_player.play()


func pause_menu_song():
	menu_song_player.stop()
	playback_pos = menu_song_player.get_playback_position()


func play_sound_rand(sounds, opts = {}):
	var vary = opts.get("vary", 0.0)

	if sounds:
		var i = randi() % sounds.size()
		var s = sounds[i]
		if vary > 0.0:
			s.pitch_scale = 1 - (randf() * vary)
		s.play()

##########################################################
# sound map api

func setup_sound(sound, opts = {}):
	var asp = AudioStreamPlayer.new()
	asp.set_stream(sound)
	asp.name = sound.resource_path.get_file()
	add_child(asp, true)
	if "is_sound" in opts and opts["is_sound"]:
		# TODO also force no looping for sounds? it's determined by the input rn
		asp.set_volume_db(default_sound_vol_db)

	if "vol_db" in opts:
		asp.set_volume_db(opts["vol_db"])

	return asp

var default_sound_vol_db = -12
var defaults = {
	"is_sound": true
	}

func setup_sound_map(sound_map, default_opts=defaults):
	var playables = {}
	for k in sound_map.keys():
		playables[k] = []
		for s in sound_map[k]:
			var sound = s
			var opts = {}
			if typeof(s) == TYPE_ARRAY:
				sound = s[0]
				opts = s[1]
			opts.merge(default_opts)
			var playable = setup_sound(sound, opts)
			playables[k].append(playable)
	return playables

func play_sound(sound_map, name):
	if name in sound_map:
		var sounds = sound_map[name]
		play_sound_rand(sounds, {"vary": 0.4})
	else:
		print("<DJ> [WARN] no sound for name", name)

func interrupt_sound(sound_map, name):
	if name in sound_map:
		for s in sound_map[name]:
			# stop any of these that are playing
			if s.is_playing():
				s.stop()
	else:
		print("<DJ> [WARN] no sound for name", name)

#################################################
# music map api

func play_song(sound_map, name):
	if name in sound_map:
		var songs = sound_map[name]
		var i = randi() % songs.size()
		var s = songs[i]
		s.play()
	else:
		print("<DJ> [WARN] no song for name", name)

func interrupt_song(sound_map, name):
	interrupt_sound(sound_map, name)
