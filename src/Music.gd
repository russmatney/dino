@tool
extends Node

# music

@onready var late_night_radio = preload("res://assets/songs/Late Night Radio.mp3")

func _ready():
	if not Engine.is_editor_hint():
		SoundManager.set_default_music_bus("Music")
		SoundManager.set_music_volume(0.3)


# 	# TODO add music controls and toasts
# 	SoundManager.stop_music(1.0)
# 	var songs = puzzle_theme.get_music_tracks()
# 	if len(songs) > 0:
# 		SoundManager.play_music(songs[0], 2.0)

# func _exit_tree():
# 	var playing_songs = SoundManager.get_currently_playing_music()
# 	if len(playing_songs) == 1:
# 		# if only one song is playing, stop it
# 		# otherwise, assume the cross-fade is working
# 		SoundManager.stop_music(2.0)
