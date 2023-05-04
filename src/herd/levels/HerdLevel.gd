extends Node2D
class_name HerdLevel


######################################################
# ready

func _ready():
	Quest.all_quests_complete.connect(on_quests_complete)
	Quest.quest_failed.connect(on_quest_failed)

	Game.maybe_spawn_player()


######################################################
# quest updates

func on_quests_complete():
	Herd.handle_level_complete()

func on_quest_failed(quest):
	Hood.notif("quest failed", quest)
	# TODO maybe with a timer before jumping?
	# OR start each level with at countdown
	Herd.retry_level()
