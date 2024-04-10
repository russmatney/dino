extends DinoLevel

## init ###################################################

func _init():
	var quest = Quest.new()
	quest.set_script(load("res://src/woods/level/QuestCatchLeaves.gd"))
	add_child(quest)
