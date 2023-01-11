tool
extends Node

onready var menu_song = preload("res://addons/dj/assets/songs/Late Night Radio.mp3")
var audio_stream_player
var playback_pos


func _ready():
	# so we can play music while paused
	pause_mode = PAUSE_MODE_PROCESS

	if menu_song:
		print(menu_song, " configured in DJ")

	audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.set_stream(menu_song)
	add_child(audio_stream_player)


# TODO support a passed song as well
# TODO may need to handle pausing the current song before overwriting here
func resume_menu_song(song = null):
	if song and menu_song != song:
		menu_song = song
		audio_stream_player.set_stream(menu_song)

	if not Engine.editor_hint:
		if playback_pos:
			audio_stream_player.play(playback_pos)
		else:
			audio_stream_player.play()


func pause_menu_song():
	audio_stream_player.stop()
	playback_pos = audio_stream_player.get_playback_position()

func setup_sound(sound):
	# TODO force no looping? it's determined by the input rn
	var asp = AudioStreamPlayer.new()
	asp.set_stream(sound)
	add_child(asp)
	return asp

func setup_sound_map(sound_map):
	var playables = {}
	for k in sound_map.keys():
		playables[k] = []
		for s in sound_map[k]:
			var playable = setup_sound(s)
			playable.set_volume_db(-12)
			playables[k].append(playable)
	return playables

func play_sound_rand(sounds):
	if sounds:
		var i = randi() % sounds.size()
		var s = sounds[i]
		s.play()
