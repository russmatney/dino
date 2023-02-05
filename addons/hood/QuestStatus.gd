extends PanelContainer

var quests

var checkbox_scene = preload("res://addons/hood/QuestStatusCheck.tscn")

func render():
	for c in get_node("%QuestList").get_children():
		c.free()

	for q in quests:
		var ch = checkbox_scene.instance()
		get_node("%QuestList").add_child(ch)
		# set after add_child, let the setter update children
		ch.quest = q


func _ready():
	Quest.connect("quest_update", self, "_on_quest_update")
	_on_quest_update()

func _on_quest_update():
	quests = Quest.active_quests.values()

	render()
