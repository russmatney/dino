@tool
extends SceneTree

var delay = 0.0
var max_delay = 15.0

func _process(delta):
	delay += delta

	if delay > max_delay:
		push_warning("Initial import complete, exiting")
		quit(0)
