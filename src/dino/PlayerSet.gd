extends Object
class_name PlayerSet

## vars #################################################

var stack = []

func spawn_new(opts):
	pass

func respawn(opts):
	# or spawn if no current

	var p = get_active_player()
	if not p:
		return spawn_new(opts)

	# TODO do respawn
	return p

func get_active_player():
	if not stack.empty():
		return stack[0]
