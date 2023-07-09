@tool
extends MetroZone
class_name SpikeZone


######################################################
# ready

func _ready():
	Quest.all_quests_complete.connect(on_quests_complete)
	super._ready()


######################################################
# quest updates

func on_quests_complete():
	DJZ.play(DJZ.S.fire)

	Quest.jumbo_notif({header="Congrats on feeding the void.", body="woo-hoo.",
		action="close", action_label_text="Next Level",
		on_close=Spike.handle_level_complete})
