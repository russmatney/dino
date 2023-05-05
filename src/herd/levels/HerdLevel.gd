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
	DJZ.play(DJZ.S.fire)
	Herd.level_complete = true
	Herd.handle_level_complete()

func on_quest_failed(_quest):
	DJZ.play(DJZ.S.heavy_fall)
	Herd.level_complete = true
	Quest.jumbo_notif({header="All the sheep died.", body="Yeesh!",
		action="close", action_label_text="Restart Level",
		on_close=Herd.retry_level})
