extends PanelContainer

var quests

var checkbox_scene = preload("res://addons/hood/QuestStatusCheck.tscn")

func render():
	for c in get_node("%QuestList").get_children():
		c.free()

	for q in quests:
		var ch = checkbox_scene.instantiate()
		get_node("%QuestList").add_child(ch)
		# set after add_child, let the setter update children
		ch.quest = q

	get_node("%Header").text = "[center]" + Quest.current_level_label


func _ready():
	Quest.quest_update.connect(_on_quest_update)
	_on_quest_update()

func _on_quest_update():
	quests = Quest.active_quests.values()

	render()
