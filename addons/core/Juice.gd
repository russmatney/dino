@tool
extends Object
class_name Juice

################################################
# slowmo toggle

static func slowmo_start():
	Debug.notif("Slooooooow mooooootion")
	Cam.start_slowmo("debug_overlay_slowmo", 0.3)

static func slowmo_stop():
	Debug.notif("Back to full speed")
	Cam.stop_slowmo("debug_overlay_slowmo")
