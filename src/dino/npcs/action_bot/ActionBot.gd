extends TopDownNPC

## process ########################################################

func _process(_delta):
	update_action_label()
	point_arrow()

	# if we can, go ahead and perform an action
	action_detector.execute_current_action()

## move_dir ########################################################

func get_move_vector():
	# TODO check the machine state here (knocked_back? talking?)
	var ax = action_detector.nearest_action()

	if ax and ax.source:
		# TODO head toward nearest part/center of the action area
		var dir = ax.source.global_position - self.global_position

		# if we're close, stop moving
		if dir.length() <= 1:
			return

		return dir.normalized()
