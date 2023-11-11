@tool
extends RunnerRoom


func is_finished():
	var leaves = U.get_children_in_group(self, "leaves")
	if leaves:
		return false
	else:
		return true
