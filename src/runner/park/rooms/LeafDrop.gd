tool
extends RunnerRoom


func is_finished():
	var leaves = Util.get_children_in_group(self, "leaves")
	if leaves:
		return false
	else:
		return true
