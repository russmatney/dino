@tool
extends DJSoundMap

###########################################################################
# sounds

var sounds = {
	"jump":
	[
			preload("res://src/mvania19/sounds/jump1.sfxr"),
		],
	"fall":
	[
			preload("res://src/mvania19/sounds/fall1.sfxr"),
			preload("res://src/mvania19/sounds/fall2.sfxr"),
			preload("res://src/mvania19/sounds/fall3.sfxr"),
		],
	"heavy_fall":
	[
			preload("res://src/mvania19/sounds/heavyfall1.sfxr"),
			preload("res://src/mvania19/sounds/heavyfall2.sfxr"),
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
