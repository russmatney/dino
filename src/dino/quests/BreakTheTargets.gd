extends Quest
class_name QuestBreakTheTargets

## ready ##########################################################

func _init():
	label = "Break The Targets"
	xs_group = "targets"
	x_update_signal = func(t): return t.destroyed
	is_remaining = func(t): return not t.is_dead
	entity_ids = [DinoEntityIds.TARGET]
