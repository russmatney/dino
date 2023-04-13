@tool
# Cam
extends Node

enum mode { FOLLOW, ANCHOR, FOLLOW_AND_POIS }

var cam_scene = preload("res://addons/camera/Cam2D.tscn")
var cam

##############################################################
# ready

func _ready():
	Debug.debug_toggled.connect(_on_debug_toggled)

func _on_debug_toggled(debugging):
	if debugging:
		Debug.pr("debugging camera!")

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


func ensure_camera(opts = {}):
	Debug.pr("ensuring camera with opts:", opts)
	if not opts is Dictionary:
		Debug.warn("unexpected ensure_camera opts value", opts)
		opts = {}

	var player = opts.get("player")

	# existing cam, lets make reparent to the passed player
	if cam and is_instance_valid(cam):
		Debug.prn("found existing cam:", cam)

		# require player group to avoid reparenting cameras on bots
		if player and player.is_in_group("player"):
			if not cam.get_parent():
				Debug.pr("Setting cam parent to player:", cam)
				cam.set_parent(player)
			if cam.get_parent() != player:
				Debug.pr("reparenting cam to player:", cam)
				cam.reparent(player)
		return

	var cams = get_tree().get_nodes_in_group("camera")
	if cams and cams.size() > 0:
		Debug.pr("Found unmanaged cams in 'camera' group, aborting 'ensure_camera'.", cams)
		return

	Debug.pr("No node found with 'camera' group, creating one.")

	cam = cam_scene.instantiate()
	cam.enabled = true
	cam.mode = opts.get("mode", mode.FOLLOW_AND_POIS)
	cam.zoom_offset = opts.get("zoom_offset", 500.0)
	cam.zoom_level = opts.get("zoom_level", 1.0)

	# zoom_rect_min, zoom_margin_min, proximity_min, proximity_max
	for k in opts:
		if k in cam:
			cam.set(k, opts.get(k))

	Navi.current_scene.add_child.call_deferred(cam)


##############################################################
# screenshake


func inc_trauma(inc = 0.1):
	if cam:
		cam.inc_trauma(inc)
	else:
		Debug.warn("inc_trauma called, but no 'cam' set.")


func screenshake(trauma = 0.3):
	inc_trauma(trauma)


##############################################################
# freezeframe


# freezeframes called in parallel may compete/reset eachother
# maybe register_slowmo is a viable workaround?
func freezeframe(name, time_scale, duration, trauma = 0.1):
	inc_trauma(trauma)
	start_slowmo(name, time_scale)
	await get_tree().create_timer(duration, true, false, true).timeout
	stop_slowmo(name)

func hitstop(name="hitstop", time_scale=0.5, duration=0.2, trauma=0.1):
	freezeframe(name, time_scale, duration, trauma)

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

var pof_group = "pofs"
var poa_group = "poas"
var poi_group = "pois"

func update_poas():
	if cam:
		cam.update_poas()

func update_pofs():
	if cam:
		# currently also called in cam._process() ...?
		cam.update_pofs()

func update_pois():
	if cam:
		cam.update_pois()


func add_to_pofs(node):
	node.add_to_group(pof_group)
	update_pofs()
func remove_from_pofs(node):
	node.remove_from_group(pof_group)
	update_pofs()

func add_to_pois(node):
	node.add_to_group(poi_group)
	update_pois()
func remove_from_pois(node):
	node.remove_from_group(poi_group)
	update_pois()

func add_to_poas(node):
	node.add_to_group(poa_group)
	update_poas()
func remove_from_poas(node):
	node.remove_from_group(poa_group)
	update_poas()

###########################################################################
# input


func _input(event):
	if Trolley.is_event(event, "zoom_in"):
		if cam:
			cam.zoom_dir("in")
	elif Trolley.is_event(event, "zoom_out"):
		if cam:
			cam.zoom_dir("out")
	if Trolley.is_action(event):
		if cam:
			# freezeframe("shake-watch", 0.2, 1.5)
			cam.inc_trauma(0.1)
