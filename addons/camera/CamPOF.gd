extends Marker2D


var active = true

func is_active():
	return active

func activate():
	active = true

func deactivate():
	active = false
