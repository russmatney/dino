class_name HarveyBot
extends HarveyPlayer

#########################################################
# ready


func _ready():
	# TODO should be a Hood.notify
	Debug.prn("HarveyBot online: ", self.name)

	# overwrite parent speed
	speed = 70

	super._ready()

#########################################################
# process


func _process(_delta):
	eval_current_action()

	# if we can, go ahead and perform an action
	if c_ax:
		perform_action()


#########################################################
# move_dir


func _unhandled_input(_event):
	pass


#########################################################
# move_dir


func get_move_dir():
	var ax = Util._or(p_ax, nearest_ax)

	if ax and "source" in ax:
		var dir = ax["source"].global_position - self.global_position

		# if we're close, stop moving
		if dir.length() <= 1:
			return

		return dir.normalized()
