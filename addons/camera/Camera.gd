@tool
# Cam
extends Node

var cam_scene = preload("res://addons/camera/Cam2D.tscn")
var cam

func prn(msg, msg2=null, msg3=null, msg4=null):
	if not msg4 == null:
		print("[CAM] ", msg, msg2, msg3, msg4)
	elif not msg3 == null:
		print("[CAM] ", msg, msg2, msg3)
	elif not msg2 == null:
		print("[CAM] ", msg, msg2)
	else:
		print("[CAM] ", msg)

##############################################################
# cam_window_rect

func cam_viewport():
	if cam:
		# TODO maybe we should create a subviewport here?
		var vp = cam.get_viewport()
		return vp


## helpful for placing 'offscreen' indicators at the edges
# tho perhaps that's easier with just a canvas layer
func cam_window_rect():
	if cam:
		var v = cam_viewport()
		var viewportRect: Rect2 = v.get_visible_rect()

		# https://github.com/godotengine/godot/issues/34805
		# TODO restore this size correction
		# var viewport_base_size = (
		# 	v.get_size_2d_override()
		# 	if v.get_size_2d_override()
		# 	else v.size
		# )
		var viewport_base_size = v.size

		var scale_factor = DisplayServer.window_get_size() / viewport_base_size
		viewportRect.size = (viewport_base_size * scale_factor) as Vector2

		# https://www.reddit.com/r/godot/comments/m8ltmd/get_screen_in_global_coords_get_visible_rect_not/
		var globalToViewportTransform: Transform2D = v.get_final_transform() * v.canvas_transform
		var viewportToGlobalTransform: Transform2D = globalToViewportTransform.affine_inverse()
		var viewportRectGlobal: Rect2 = viewportToGlobalTransform * viewportRect

		return viewportRectGlobal


##############################################################
# ensure camera


func ensure_camera(cam_mode = null, opts={}):
	if not opts is Dictionary:
		opts = {}
		prn("[WARN] overwriting/ignoring camera opts")

	prn("ensuring camera")
	if cam and is_instance_valid(cam):
		prn("found existing cam: ", cam)
		return

	var cams = get_tree().get_nodes_in_group("camera")
	if cams:
		return

	prn("No node found with 'camera' group, adding one.")

	cam = cam_scene.instantiate()
	cam.enabled = true
	cam.zoom_offset = opts.get("zoom_offset", 500.0)
	cam.zoom_level = opts.get("zoom_level", 1.0)

	if cam_mode:
		cam.mode = cam_mode

	Navi.current_scene.call_deferred("add_child", cam)


##############################################################
# screenshake


func inc_trauma(inc = 0.1):
	if cam:
		cam.inc_trauma(inc)
	else:
		prn("[WARN]: inc_trauma called, but no 'cam' set.")


func screenshake(trauma = 0.3):
	inc_trauma(trauma)


##############################################################
# freezeframe


# freezeframes called in parallel may compete/reset eachother
# maybe register_slowmo is a viable workaround?
func freezeframe(name, time_scale, duration, trauma = 0.1):
	inc_trauma(trauma)
	start_slowmo(name, time_scale)
	await get_tree().create_timer(duration * time_scale).timeout
	stop_slowmo(name)

func hitstop(name, time_scale, duration, trauma=0.1):
	freezeframe(name, time_scale, duration, trauma)

##############################################################
# slowmo

signal slowmo_stopped(label)

# ordered dict?
var slowmos = []
var slowmo_scales = {}


func start_slowmo(label, scale = 0.5):
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
	if slowmos.is_empty() or slowmo_scales.is_empty():
		Engine.time_scale = 1.0
		return

	var l = slowmos[0]
	# maybe a bug here if two targets are destroyed at the same time
	if l in slowmo_scales:
		var scale = slowmo_scales[l]
		Engine.time_scale = scale


####################################################################
# zoom

func zoom_to(level=null):
	cam.zoom_dir("to", level)

func zoom_in(n_levels=null):
	cam.zoom_dir("in", n_levels)

func zoom_out(n_levels=null):
	cam.zoom_dir("out", n_levels)


####################################################################
# focus

var pof_group = "pof"
var poi_group = "poi"

func update_pofs():
	if cam:
		# currently also called in cam._process() ...?
		cam.update_pofs()

func update_pois():
	if cam:
		cam.update_pois()
