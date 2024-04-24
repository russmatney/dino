extends PanelContainer

@onready var header = $%Header
@onready var quest_list = $%QuestList

@export var header_text: String

var quests

var checkbox_scene = preload("res://addons/core/quest/QuestStatusCheck.tscn")

func render():
	for c in quest_list.get_children():
		c.queue_free()

	for q in quests:
		var ch = checkbox_scene.instantiate()
		quest_list.add_child(ch)
		# set after add_child, let the setter update children
		ch.quest = q

	if header_text != null and len(header_text) > 0:
		header.text = "[center]%s[/center]" % header_text


func _ready():
	# TODO seek out and connect to quest_managers in the tree
	# Q.quest_update.connect(_on_quest_update)
	_on_quest_update()

func _on_quest_update():
	quests = []
	# quests = Q.active_quests.values()

	render()
