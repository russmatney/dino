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
}
var sound_map


func setup_sounds():
	sound_map = DJ.setup_sound_map(sounds)


func play_sound(name):
	DJ.play_sound(sound_map, name)


func interrupt_sound(name):
	DJ.interrupt_sound(sound_map, name)
