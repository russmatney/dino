# Cam
extends Node

var cam_scene = preload("res://addons/camera/Cam2D.tscn")
var cam

##############################################################
# ensure camera

func ensure_camera(cam_mode = null):
	print("ensuring camera")

	if cam and is_instance_valid(cam):
		print("found cam: ", cam)
		return

	var cams = get_tree().get_nodes_in_group("camera")
	if cams:
		return

	print("[CAM]: No node found with 'camera' group, adding one.")

	cam = cam_scene.instance()
	cam.current = true

	if cam_mode:
		cam.mode = cam_mode

	Navi.current_scene.call_deferred("add_child", cam)

##############################################################
# screenshake

func screenshake(opts = {}):
	if cam:
		cam.screenshake(opts)
	else:
		print("[WARN]: screenshake called, but no 'cam' set.")

##############################################################
# freezeframe

# freezeframes called in parallel may compete/reset eachother
# maybe register_slowmo is a viable workaround?
func freezeframe(name, time_scale, duration):
	start_slowmo(name, time_scale)
	yield(get_tree().create_timer(duration * time_scale), "timeout")
	print("freeze frame done, resuming")
	stop_slowmo(name)

##############################################################
# slowmo

signal slowmo_stopped(label)

# ordered dict?
var slowmos = []
var slowmo_scales = {}

func start_slowmo(label, scale):
	print("[CAM] start slowmo: ", label, " scale: ", scale)
	slowmos.append(label)
	slowmo_scales[label] = scale
	Engine.time_scale = scale

func stop_slowmo(label):
	print("[CAM] stop slowmo: ", label)
	slowmos.erase(label)
	slowmo_scales.erase(label)
	emit_signal("slowmo_stopped", label)
	resume_slowmo()

func clear_all_slowmos():
	slowmos.clear()
	slowmo_scales.clear()
	Engine.time_scale = 1.0

# resumes normal time if no slowmos remain
func resume_slowmo():
	if slowmos.empty() or slowmo_scales.empty():
		print("[Cam] resuming normal speed")
		Engine.time_scale = 1.0
		return

	var l = slowmos[0]
	if l in slowmo_scales:
		var scale = slowmo_scales[l]
		Engine.time_scale = scale
