extends PanelContainer

var quests setget set_quests

func set_quests(qs):
	quests = qs
	render()

var checkbox_scene = preload("res://addons/hood/QuestStatusCheck.tscn")

func render():
	for c in get_node("%QuestList").get_children():
		c.free()

	for q in quests:
		var ch = checkbox_scene.instance()
		get_node("%QuestList").add_child(ch)
		ch.quest = q
