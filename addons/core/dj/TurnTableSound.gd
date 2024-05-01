@tool
extends HBoxContainer

@onready var sound_name = $%SoundName
@onready var play_button = $%PlayButton
@onready var stop_button = $%StopButton

var sound_name_text: String

func _ready():
	play_button.pressed.connect(_on_play_pressed)
	stop_button.pressed.connect(_on_stop_pressed)

func _on_play_pressed():
	Sounds.play(Sounds.S[sound_name_text])

func _on_stop_pressed():
	Sounds.interrupt(Sounds.S[sound_name_text])

func set_sound(text):
	sound_name_text = text
	sound_name.set_text(text)
