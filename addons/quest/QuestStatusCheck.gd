extends HBoxContainer

var quest: QuestData : set = set_quest

func set_quest(q):
	quest = q

	if quest:
		$CheckBox.text = status_label()
		$CheckBox.button_pressed = quest.complete

func status_label():
	var label
	if quest.total:
		label = str(quest.label, " (", quest.total - quest.remaining, "/", quest.total, ")")
	else:
		label = quest.label

	if quest.optional:
		label += " (optional)"

	if quest.failed:
		label = "[FAILED] " + label

	return label

func _ready():
	pass # Replace with function body.


