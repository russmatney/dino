@tool
extends HBoxContainer

@onready var sound_name = $%SoundName
@onready var play_button = $%PlayButton

var sound_name_text: String

func _ready():
	play_button.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	DJZ.play(DJZ.S[sound_name_text])

func set_sound(text):
	sound_name_text = text
	sound_name.set_text(text)
