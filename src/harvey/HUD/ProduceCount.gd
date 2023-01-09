extends HBoxContainer

onready var count_label = $Count
onready var produce_icon = $MarginContainer/ProduceIcon

func set_count(n):
	count_label.text = "x " + str(n)

func set_produce(type):
	produce_icon.animation = type
