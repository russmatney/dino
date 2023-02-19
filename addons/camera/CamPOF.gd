extends Marker2D


var active = true

func pof_active():
	return active

func activate():
	active = true

func deactivate():
	active = false
