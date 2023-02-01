tool
extends HBoxContainer

onready var count_label = $Count
onready var produce_icon = $MarginContainer/ProduceIcon


func set_count(n):
	count_label.text = "x " + str(n)


func set_produce(type):
	produce_icon.animation = type


func _ready():
	if Engine.editor_hint:
		set_count(5)
		set_produce("carrot")
