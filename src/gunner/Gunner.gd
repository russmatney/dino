extends Node

func _ready():
	print("gunner")

	setup_sounds()


###########################################################################
# sounds

onready var sounds = {
	"fire": [
		preload("res://assets/sounds/laser1.sfxr"),
		preload("res://assets/sounds/laser2.sfxr"),
		],
	"jump": [
		preload("res://assets/sounds/jump1.sfxr"),
		preload("res://assets/sounds/jump2.sfxr"),
		preload("res://assets/sounds/jump3.sfxr"),
		],
	}
var sound_map
onready var laser_stream = preload("res://assets/harvey/sounds/slime_001.ogg")

func setup_sounds():
	sound_map = DJ.setup_sound_map(sounds)

func play_sound(name):
	if name in sound_map:
		DJ.play_sound_rand(sound_map[name])
	else:
		print("[WARN]: no sound for name", name)
