# Cam
extends Node

var cam_scene = preload("res://addons/camera/Cam2D.tscn")
var cam


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


func screenshake(opts = {}):
	if cam:
		cam.screenshake(opts)
	else:
		print("[WARN]: screenshake called, but no 'cam' set.")


func freezeframe(time_scale, duration):
	Engine.time_scale = time_scale
	yield(get_tree().create_timer(duration * time_scale), "timeout")
	Engine.time_scale = 1.0
