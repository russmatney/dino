class_name HarveyBot
extends HarveyPlayer

## ready #########################################################

func _ready():
	# TODO should be a Hood.notify
	Debug.prn("HarveyBot online: ", self.name)

	speed = 70

	super._ready()

## process ########################################################

func _process(_delta):
	update_action_label()
	point_arrow()

	# if we can, go ahead and perform an action
	action_detector.execute_current_action()

## move_dir ########################################################

func get_move_dir():
	var ax = action_detector.nearest_action()

	if ax and ax.source:
		var dir = ax.source.global_position - self.global_position

		# if we're close, stop moving
		if dir.length() <= 1:
			return

		return dir.normalized()
