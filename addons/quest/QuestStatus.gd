extends PanelContainer

@onready var header = $%Header
@onready var quest_list = $%QuestList

@export var header_text: String

var quests

var checkbox_scene = preload("res://addons/quest/QuestStatusCheck.tscn")

func render():
	for c in quest_list.get_children():
		c.free()

	for q in quests:
		var ch = checkbox_scene.instantiate()
		quest_list.add_child(ch)
		# set after add_child, let the setter update children
		ch.quest = q

	if header_text != null and len(header_text) > 0:
		header.text = "[center]%s[/center]" % header_text
	else:
		header.text = "[center]%s[/center]" % Quest.current_level_label


func _ready():
	Quest.quest_update.connect(_on_quest_update)
	_on_quest_update()

func _on_quest_update():
	quests = Quest.active_quests.values()

	render()
