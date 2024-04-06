@tool
extends Node
class_name J

################################################
# slowmo toggle

static func slowmo_start():
	Debug.notif("Slooooooow mooooootion")
	Juice.start_slowmo("basic_slowmo", 0.3)

static func slowmo_stop():
	Debug.notif("Back to full speed")
	Juice.stop_slowmo("basic_slowmo")

##############################################################
# slowmo

signal slowmo_stopped(label)

# ordered dict?
var slowmos = []
var slowmo_scales = {}


func start_slowmo(label, scale = 0.5):
	# Debug.debug_label("[CAM] start slowmo: ", label, " scale: ", scale)
	slowmos.append(label)
	slowmo_scales[label] = scale
	Engine.time_scale = scale


func stop_slowmo(label):
	# Debug.debug_label("[CAM] stop slowmo: ", label)
	slowmos.erase(label)
	slowmo_scales.erase(label)
	slowmo_stopped.emit(label)
	resume_slowmo()


func clear_all_slowmos():
	slowmos.clear()
	slowmo_scales.clear()
	Engine.time_scale = 1.0


# resumes normal time if no slowmos remain
func resume_slowmo():
	if slowmos.is_empty() or slowmo_scales.is_empty():
		Engine.time_scale = 1.0
		return

	var l = slowmos[0]
	# maybe a bug here if two targets are destroyed at the same time
	if l in slowmo_scales:
		var scale = slowmo_scales[l]
		Engine.time_scale = scale
