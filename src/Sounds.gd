@tool
extends DJSoundMap

enum S {
	candlelit,
	candleout,
	coin,
	complete,
	cure,
	dot_collected,
	gong,
	laser,
	maximize,
	minimize,
	showjumbotron,
	step,
	ui_dading,
	}

###########################################################################
# sounds

@onready var sounds = {
	S.candlelit:
	[
			preload("res://assets/sounds/candlelit1.sfxr"),
			preload("res://assets/sounds/candlelit2.sfxr"),
		],
	S.candleout:
	[
			preload("res://assets/sounds/candleout1.sfxr"),
			preload("res://assets/sounds/candleout2.sfxr"),
		],
	S.coin:
	[
			# preload("res://assets/sounds/coin1.sfxr"),
			preload("res://assets/sounds/coin2.sfxr"),
			# preload("res://assets/sounds/coin3.sfxr"),
		],
	S.complete: [
		preload("res://assets/sounds/Retro Game Weapons Sound Effects - complete.ogg")
		],
	S.cure: [
		preload("res://assets/sounds/Retro Game Weapons Sound Effects - cure.ogg")
		],
	S.dot_collected: [
		preload("res://assets/sounds/Retro Game Weapons Sound Effects - cure.ogg"),
		],
	S.gong: [
		preload("res://assets/sounds/266566__gowlermusic__gong-hit.wav"),
		],
	S.laser:
	[
		preload("res://assets/sounds/laser1.sfxr"),
		preload("res://assets/sounds/laser2.sfxr"),
		preload("res://assets/sounds/laser3.sfxr"),
		preload("res://assets/sounds/laser4.sfxr"),
		preload("res://assets/sounds/laser5.sfxr"),
	],
	S.maximize: [preload("res://assets/sounds/maximize_006.ogg")],
	S.minimize: [preload("res://assets/sounds/minimize_006.ogg")],
	S.showjumbotron:
	[
			preload("res://assets/sounds/showjumbotron1.sfxr"),
			preload("res://assets/sounds/showjumbotron2.sfxr"),
			preload("res://assets/sounds/showjumbotron3.sfxr"),
		],
	S.step:
	[
		preload("res://assets/sounds/step1.sfxr"),
		preload("res://assets/sounds/step2.sfxr"),
	],
	S.ui_dading:
	[
		preload("res://assets/sounds/ui_dading.sfxr"),
		preload("res://assets/sounds/ui_dading1.sfxr"),
		preload("res://assets/sounds/ui_dading2.sfxr"),
	],
}

func _ready():
	if not Engine.is_editor_hint():
		SoundManager.set_default_sound_bus("Sound")
		SoundManager.set_default_ui_sound_bus("UI Sound")
		SoundManager.set_sound_volume(0.3)

	super._ready()

####################################################################

func _enter_tree() -> void:
	if not Engine.is_editor_hint():
		get_tree().node_added.connect(on_node_added)

func on_node_added(node: Node):
	if node is Button:
		node.focus_entered.connect(on_button_focused.bind(node))
		node.pressed.connect(on_button_pressed.bind(node))

func on_button_focused(button: Button) -> void:
	if button.is_visible_in_tree():
		play(S.step)

func on_button_pressed(_button: Button) -> void:
	play(S.ui_dading)
