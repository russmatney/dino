extends HBoxContainer

var quest: ActiveQuest setget set_quest

func set_quest(q):
	quest = q

	if quest:
		$CheckBox.text = quest.label
		$CheckBox.pressed = quest.complete

func _ready():
	pass # Replace with function body.


