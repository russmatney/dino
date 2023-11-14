extends Quest
class_name QuestFeedTheVoid


func _init():
	label = "Feed The Voids"
	get_xs_group = "voids"
	x_update_signal = func(x): return x.void_satisfied
	is_remaining = func(x): return not x.complete
