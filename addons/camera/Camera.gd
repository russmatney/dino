# Cam
extends Node

var cam_scene = preload("res://addons/camera/Cam2D.tscn")
var cam

func ensure_camera(cam_mode = null):
	if cam:
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
