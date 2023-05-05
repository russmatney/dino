extends Control

@onready var sheep_name = $%SheepName
@onready var hearts_container = $%HeartsContainer

func set_sheep_name(text):
	sheep_name.set_text("[center]%s" % text)

func set_health(health):
	hearts_container.h = health
