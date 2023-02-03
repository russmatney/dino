extends Node


func _ready():
	setup_sounds()


###########################################################################
# sounds

onready var sounds = {
	"walk":
	[
			preload("res://assets/sounds/snake/walk1.sfxr"),
			preload("res://assets/sounds/snake/walk2.sfxr"),
		],
	"pickup":
	[
		preload("res://assets/sounds/snake/pickup1.sfxr"),
		preload("res://assets/sounds/snake/pickup2.sfxr"),
		preload("res://assets/sounds/snake/pickup3.sfxr"),
		preload("res://assets/sounds/snake/pickup4.sfxr"),
		preload("res://assets/sounds/snake/pickup5.sfxr"),
	],
	"bump":
	[
		preload("res://assets/sounds/snake/bump1.sfxr"),
		preload("res://assets/sounds/snake/bump2.sfxr"),
		preload("res://assets/sounds/snake/bump3.sfxr"),
	],
	"speedup":
	[
		preload("res://assets/sounds/snake/speedup1.sfxr"),
		preload("res://assets/sounds/snake/speedup2.sfxr"),
		preload("res://assets/sounds/snake/speedup3.sfxr"),
	],
	"cool-kids":
	[
		[
			preload("res://assets/music/sulosounds/cool-kids-electronic-bass-groo.wav"),
			{"is_sound": false}
		],
	],
	"chill-electric":
	[
		[
			preload("res://assets/music/sulosounds/chill-electric-background.wav"),
			{"is_sound": false}
		],
	],
	"evening-dogs":
	[
		[
			preload("res://assets/music/sulosounds/evening-dogs.wav"),
			{"is_sound": false}
		],
	],
	"funk-till-five":
	[
		[
			preload("res://assets/music/sulosounds/funk-till-five-loop.wav"),
			{"is_sound": false}
		],
	],
	"funkmachine":
	[
		[
			preload("res://assets/music/sulosounds/funkmachine-master-loop.wav"),
			{"is_sound": false}
		],
	],
	"field-stars":
	[
		[
			preload("res://assets/music/sulosounds/field-stars-ambient-loop.wav"),
			{"is_sound": false}
		],
	],
}
var sound_map

func setup_sounds():
	sound_map = DJ.setup_sound_map(sounds)

func play_sound(name):
	DJ.play_sound(sound_map, name)

func interrupt_sound(name):
	DJ.interrupt_sound(sound_map, name)

func play_song(name):
	DJ.play_song(sound_map, name)

func interrupt_song(name):
	DJ.interrupt_song(sound_map, name)
