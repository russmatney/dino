@tool
extends DJSoundMap

enum {
	jump,
	fall,
	heavy_fall,
	coin,
	swordswing,
	soldierhit,
	soldierdead,
	}

###########################################################################
# sounds

var sounds = {
	jump:
	[
			preload("res://src/mvania19/sounds/jump1.sfxr"),
		],
	fall:
	[
			preload("res://src/mvania19/sounds/fall1.sfxr"),
			preload("res://src/mvania19/sounds/fall2.sfxr"),
			preload("res://src/mvania19/sounds/fall3.sfxr"),
		],
	heavy_fall:
	[
			preload("res://src/mvania19/sounds/heavyfall1.sfxr"),
			preload("res://src/mvania19/sounds/heavyfall2.sfxr"),
		],
	coin:
	[
			preload("res://src/mvania19/sounds/coin1.sfxr"),
			preload("res://src/mvania19/sounds/coin2.sfxr"),
			preload("res://src/mvania19/sounds/coin3.sfxr"),
		],
	swordswing:
	[
			preload("res://src/mvania19/sounds/swordswing1.sfxr"),
			preload("res://src/mvania19/sounds/swordswing2.sfxr"),
			preload("res://src/mvania19/sounds/swordswing3.sfxr"),
		],
	soldierhit:
	[
			preload("res://src/mvania19/sounds/soldierhit.sfxr"),
			preload("res://src/mvania19/sounds/soldierhit1.sfxr"),
			preload("res://src/mvania19/sounds/soldierhit2.sfxr"),
		],
	soldierdead:
	[
			preload("res://src/mvania19/sounds/soldierdead1.sfxr"),
			preload("res://src/mvania19/sounds/soldierdead2.sfxr"),
			preload("res://src/mvania19/sounds/soldierdead3.sfxr"),
		],
}
