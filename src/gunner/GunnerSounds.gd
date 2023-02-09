extends Node


func _ready():
	setup_sounds()


###########################################################################
# sounds

@onready var sounds = {
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
	"jet_init":
	[
		preload("res://assets/sounds/jet1.sfxr"),
	],
	"jet_boost":
	[
		preload("res://assets/sounds/jet2.sfxr"),
		preload("res://assets/sounds/jet3.sfxr"),
	],
	"jet_echo":
	[
		preload("res://assets/sounds/jet_echo1.sfxr"),
		preload("res://assets/sounds/jet_echo2.sfxr"),
	],
	"heavy_landing":
	[
		preload("res://assets/sounds/small_explosion.sfxr"),
		preload("res://assets/sounds/heavy_landing1.sfxr"),
	],
	"bullet_pop":
	[
		preload("res://assets/sounds/small_explosion.sfxr"),
	],
	"pickup":
	[
		preload("res://assets/sounds/pickup1.sfxr"),
	],
	"target_kill":
	[
		preload("res://assets/sounds/coin1.sfxr"),
		preload("res://assets/sounds/coin2.sfxr"),
		preload("res://assets/sounds/coin3.sfxr"),
	],
	"player_hit":
	[
		preload("res://assets/sounds/player_hurt1.sfxr"),
	],
	"player_dead":
	[
		preload("res://assets/sounds/player_dead1.sfxr"),
	],
	"player_spawn":
	[
		preload("res://assets/sounds/player_spawn1.sfxr"),
	],
	"enemy_spawn":
	[
		preload("res://assets/sounds/enemy_spawn2.sfxr"),
	],
	"enemy_sees_you":
	[
		preload("res://assets/sounds/enemy_sees_you1.sfxr"),
	],
	"enemy_hit":
	[
		preload("res://assets/sounds/enemy_hurt1.sfxr"),
	],
	"enemy_dead":
	[
		preload("res://assets/sounds/enemy_dead1.sfxr"),
	],
}
var sound_map


func setup_sounds():
	sound_map = DJ.setup_sound_map(sounds)


func play_sound(name):
	DJ.play_sound(sound_map, name)


func interrupt_sound(name):
	DJ.interrupt_sound(sound_map, name)
