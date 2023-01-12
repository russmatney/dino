extends Node


func _ready():
	print("gunner")

	setup_sounds()


###########################################################################
# sounds

onready var sounds = {
	"fire":
	[
		preload("res://assets/sounds/laser1.sfxr"),
		preload("res://assets/sounds/laser2.sfxr"),
	],
	"jump":
	[
		preload("res://assets/sounds/jump1.sfxr"),
		preload("res://assets/sounds/jump2.sfxr"),
		preload("res://assets/sounds/jump3.sfxr"),
	],
	"step":
	[
		preload("res://assets/sounds/step1.sfxr"),
		preload("res://assets/sounds/step2.sfxr"),
		preload("res://assets/sounds/step3.sfxr"),
	],
	"land":
	[
		preload("res://assets/sounds/step1.sfxr"),
		preload("res://assets/sounds/step2.sfxr"),
		preload("res://assets/sounds/step3.sfxr"),
	],
	"bullet_pop":
	[
		preload("res://assets/sounds/small_explosion.sfxr"),
	],
	"target_kill":
	[
		preload("res://assets/sounds/coin1.sfxr"),
		preload("res://assets/sounds/coin2.sfxr"),
		preload("res://assets/sounds/coin3.sfxr"),
	]
}
var sound_map
onready var laser_stream = preload("res://assets/harvey/sounds/slime_001.ogg")


func setup_sounds():
	sound_map = DJ.setup_sound_map(sounds)


func play_sound(name):
	if name in sound_map:
		var s = sound_map[name]
		DJ.play_sound_rand(s, {"vary": 0.3})
	else:
		print("[WARN]: no sound for name", name)
