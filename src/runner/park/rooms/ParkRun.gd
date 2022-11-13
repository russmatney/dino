tool
extends RunnerRoom


func is_finished():
	var coins = Util.get_children_in_group(self, "coin")
	if coins:
		return false
	else:
		return true
