# Cam
extends Node

var cam_scene = preload("res://addons/camera/Cam2D.tscn")
var cam

func cam_viewport():
	if cam:
		return cam.get_viewport()

func cam_window_rect():
	var v: Viewport = cam.get_viewport()
	var viewportRect: Rect2 = v.get_visible_rect()

	# https://github.com/godotengine/godot/issues/34805
	var viewport_base_size = (
		v.get_size_override() if v.get_size_override() > Vector2(0, 0)
		else v.size
	)
	var scale_factor = OS.window_size / viewport_base_size
	viewportRect.size = viewport_base_size * scale_factor

	# https://www.reddit.com/r/godot/comments/m8ltmd/get_screen_in_global_coords_get_visible_rect_not/
	var globalToViewportTransform: Transform2D = v.get_final_transform() * v.canvas_transform
	var viewportToGlobalTransform: Transform2D = globalToViewportTransform.affine_inverse()
	var viewportRectGlobal: Rect2 = viewportToGlobalTransform.xform(viewportRect)

	return viewportRectGlobal

##############################################################
# ensure camera

func ensure_camera(cam_mode = null, zoom_offset=3000):
	if cam and is_instance_valid(cam):
		print("[CAM] found existing cam: ", cam)
		return

	var cams = get_tree().get_nodes_in_group("camera")
	if cams:
		return

	print("[CAM]: No node found with 'camera' group, adding one.")

	cam = cam_scene.instance()
	cam.current = true
	cam.zoom_offset = zoom_offset

	if cam_mode:
		cam.mode = cam_mode

	Navi.current_scene.call_deferred("add_child", cam)

##############################################################
# screenshake

func inc_trauma(inc = 0.1):
	if cam:
		cam.inc_trauma(inc)
	else:
		print("[WARN]: inc_trauma called, but no 'cam' set.")

func screenshake(trauma = 0.3):
	inc_trauma(trauma)

##############################################################
# freezeframe

# freezeframes called in parallel may compete/reset eachother
# maybe register_slowmo is a viable workaround?
func freezeframe(name, time_scale, duration):
	start_slowmo(name, time_scale)
	yield(get_tree().create_timer(duration * time_scale), "timeout")
	stop_slowmo(name)

##############################################################
# slowmo

signal slowmo_stopped(label)

# ordered dict?
var slowmos = []
var slowmo_scales = {}

func start_slowmo(label, scale):
	# print("[CAM] start slowmo: ", label, " scale: ", scale)
	slowmos.append(label)
	slowmo_scales[label] = scale
	Engine.time_scale = scale

func stop_slowmo(label):
	# print("[CAM] stop slowmo: ", label)
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
		Engine.time_scale = 1.0
		return

	var l = slowmos[0]
	# maybe a bug here if two targets are destroyed at the same time
	if l in slowmo_scales:
		var scale = slowmo_scales[l]
		Engine.time_scale = scale
