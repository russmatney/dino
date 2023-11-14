extends Quest
class_name QuestCollectGems

func _init():
	label = "Collect All Gems"
	get_xs_group = "gems"
	x_update_signal = func(x): return x.tree_exited
	is_remaining = func(_x): return true
