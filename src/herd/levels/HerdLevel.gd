extends Node2D
class_name HerdLevel


######################################################
# ready

func _ready():
	Quest.all_quests_complete.connect(on_quests_complete)
	Quest.quest_failed.connect(on_quest_failed)
	Quest.quest_update.connect(on_quest_update)

	Game.maybe_spawn_player()


######################################################
# quest updates

func on_quests_complete():
	Hood.notif("quests complete")

func on_quest_failed(quest):
	Hood.notif("quest failed", quest)

func on_quest_update():
	# Debug.pr("quest update")
	pass
