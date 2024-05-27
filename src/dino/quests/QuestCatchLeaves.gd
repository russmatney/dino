extends Quest
class_name QuestCatchLeaves

func _init():
	label = "Catch The Leaves"
	xs_group = "leaves"
	x_update_signal = func(x): return x.caught
	is_remaining = func(x): return not x.is_caught
	entity_ids = [DinoEntityIds.LEAF]
