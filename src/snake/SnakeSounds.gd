@tool
extends Node


func _ready():
	setup_sounds()


###########################################################################
# sounds

@onready var sounds = {
	"walk":
	[
			preload("res://assets/sounds/snake/walk1.sfxr"),
			preload("res://assets/sounds/snake/walk2.sfxr"),
		],
	"laser":
	[
		preload("res://assets/sounds/snake/laser1.sfxr"),
		preload("res://assets/sounds/snake/laser2.sfxr"),
		preload("res://assets/sounds/snake/laser3.sfxr"),
		preload("res://assets/sounds/snake/laser4.sfxr"),
		preload("res://assets/sounds/snake/laser5.sfxr"),
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

func play_sound(nm):
	DJ.play_sound(sound_map, nm)

func interrupt_sound(nm):
	DJ.interrupt_sound(sound_map, nm)

func play_song(nm):
	DJ.play_song(sound_map, nm)

func interrupt_song(nm):
	DJ.interrupt_song(sound_map, nm)
