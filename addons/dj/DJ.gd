@tool
extends Node

# maybe drop preload
var menu_song = preload("res://addons/dj/assets/songs/Late Night Radio.mp3")
var menu_song_player
var playback_pos

## ready ######################################################################

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	menu_song_player = setup_sound(menu_song, {"is_sound": false})

func resume_menu_song(song = null):
	if muted_music:
		Log.warn("Cannot resume menu song, music is muted")
		return

	if song and menu_song != song:
		menu_song = song
		menu_song_player.set_stream(menu_song)

	if not Engine.is_editor_hint():
		if playback_pos:
			menu_song_player.play(playback_pos)
		else:
			menu_song_player.play()

func pause_menu_song():
	if muted_music:
		Log.warn("Cannot play menu song, music is muted")
		return
	menu_song_player.stop()
	playback_pos = menu_song_player.get_playback_position()

func play_sound_rand(sounds, opts = {}):
	var vary = opts.get("vary", 0.0)

	if sounds:
		var i = randi() % sounds.size()
		var s = sounds[i]
		if not is_instance_valid(s):
			return
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
		# how to force no looping for sounds? it's determined by the input rn
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
	if muted_sound:
		Log.warn("Cannot play sound, sounds are muted")
		return
	if name in sound_map:
		var sounds = sound_map[name]
		play_sound_rand(sounds, {"vary": 0.4})
	else:
		Log.warn("no sound for name", name)

func interrupt_sound(sound_map, name):
	if name in sound_map:
		for s in sound_map[name]:
			# stop any of these that are playing
			if s.is_playing():
				s.stop()
				return s
	else:
		Log.warn("no sound for name", name)


#################################################
# music map api

var playing_game_songs = []
var paused_game_songs = []

func play_song(sound_map, name):
	if muted_music:
		Log.warn("Cannot play song, music is muted")
		return
	if name in sound_map:
		var songs = sound_map[name]
		var i = randi() % songs.size()
		var s = songs[i]
		# if already playing, do nothing
		if not s.playing:
			s.play()
			playing_game_songs.append(s)
	else:
		Log.warn("no song for name", name)

func interrupt_song(sound_map, name):
	var song = interrupt_sound(sound_map, name)
	if song:
		playing_game_songs.erase(song)

func pause_game_song():
	paused_game_songs = []
	for song in playing_game_songs:
		if song.playing:
			song.stop()
			paused_game_songs.append([song, song.get_playback_position()])

func resume_game_song():
	if muted_music:
		Log.warn("Cannot resume game song, music is muted")
		return
	# could store and resume at same playback_position
	for song_and_pos in paused_game_songs:
		var song = song_and_pos[0]
		var pos = song_and_pos[1]
		song.play(pos)


## mute ######################################################################

var muted_sound = false
var muted_music = false
signal mute_toggle

func mute_all():
	toggle_mute_music(true)
	toggle_mute_sound(true)

func toggle_mute_music(should_mute=null):
	if should_mute == null:
		muted_music = not muted_music
	else:
		muted_music = should_mute

	if muted_music:
		pause_game_song()
	else:
		resume_game_song()

	mute_toggle.emit()

func toggle_mute_sound(should_mute=null):
	if should_mute == null:
		muted_sound = not muted_sound
	else:
		muted_sound = should_mute
	mute_toggle.emit()
