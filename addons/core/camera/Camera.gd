@tool
# Cam
extends Node

enum mode { FOLLOW, ANCHOR, FOLLOW_AND_POIS }

var cam_scene = preload("res://addons/core/camera/Cam2D.tscn")
var cam

## ready #############################################################

func _ready():
	Debug.debug_toggled.connect(_on_debug_toggled)

func _on_debug_toggled(debugging):
	if debugging:
		Log.pr("debugging camera!")

## cam_window_rect #############################################################

## helpful for placing 'offscreen' indicators at the edges
# tho perhaps that's easier with just a canvas layer
func cam_window_rect():
	var v = get_viewport()
	var viewportRect: Rect2 = v.get_visible_rect()

	# https://github.com/godotengine/godot/issues/34805
	# restore this size correction
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

    # does this work?
	# https://www.reddit.com/r/godot/comments/rzmfh3/is_there_a_way_to_get_the_rect2_of_the_camera/
	# return get_canvas_transform().affine_inverse().basis_xform(get_viewport_rect().size)

## request camera #############################################################

var spawning_camera

func request_camera(opts = {}):
	if not opts is Dictionary:
		Log.warn("unexpected request_camera opts value", opts)
		opts = {}

	if spawning_camera:
		# Log.warn("already spawning camera, ignoring request_camera call", opts)
		return cam

	var player = opts.get("player")
	var anchor = opts.get("anchor")
	var cam_mode = opts.get("mode", mode.FOLLOW_AND_POIS)

	# existing cam, lets make reparent to the passed player
	if cam and is_instance_valid(cam):
		# Log.pr("freeing existing camera, creating a new one")
		# cam.free()
		# make sure existing cam matches the requested cam

		# require player group to avoid reparenting cameras on bots
		if player and player.is_in_group("player"):
			if cam.get_parent() == player:
				# Log.pr("player already has cam parent")
				return cam

			var cam_parent = cam.get_parent()
			if cam_parent != null and is_instance_valid(cam_parent) and cam.get_parent() != player:
				Log.pr("reparenting cam to player:", cam)
				cam.reparent(player)
			else:
				Log.pr("Setting cam parent to player:", cam)
				player.add_child(cam)

		if cam_mode == mode.ANCHOR and anchor:
			var cam_parent = cam.get_parent()
			if cam_parent == null or not is_instance_valid(cam_parent) or cam_parent != anchor:
				cam.reparent(anchor, false)

		return cam

	var cams = get_tree().get_nodes_in_group("camera")
	if cams and cams.size() > 0:
		Log.pr("Found unmanaged cams in 'camera' group, aborting 'request_camera'.", cams)
		return cam

	cam = cam_scene.instantiate()
	cam.enabled = true
	cam.mode = cam_mode
	cam.zoom_offset = opts.get("zoom_offset", 500.0)
	cam.zoom_level = opts.get("zoom_level", 1.0)

	# zoom_rect_min, zoom_margin_min, proximity_min, proximity_max
	for k in opts:
		if k in cam:
			cam.set(k, opts.get(k))

	spawning_camera = true
	cam.ready.connect(func(): spawning_camera = false, CONNECT_ONE_SHOT)

	var cs = get_tree().current_scene
	if cs:
		cs.add_child.call_deferred(cam)

	return cam


##############################################################
# screenshake


func inc_trauma(inc = 0.1):
	if cam and is_instance_valid(cam):
		cam.inc_trauma(inc)
	else:
		Log.warn("inc_trauma called, but no valid 'cam' set.")


func screenshake(trauma = 0.3):
	inc_trauma(trauma)

func screenshake_cancel():
	if cam and is_instance_valid(cam):
		cam.set_trauma(0.0)


##############################################################
# freezeframe

# could refactor into opts based map apis

# freezeframes called in parallel may compete/reset eachother
# maybe register_slowmo is a viable workaround?
func freezeframe(name, time_scale, duration, trauma = 0.1):
	inc_trauma(trauma)
	Juice.start_slowmo(name, time_scale)
	await get_tree().create_timer(duration, true, false, true).timeout
	Juice.stop_slowmo(name)

func hitstop(name="hitstop", time_scale=0.5, duration=0.2, trauma=0.1):
	freezeframe(name, time_scale, duration, trauma)


####################################################################
# zoom

func zoom_to(level=null):
	if cam and is_instance_valid(cam):
		cam.zoom_dir("to", level)

func zoom_in(n_levels=null):
	if cam and is_instance_valid(cam):
		cam.zoom_dir("in", n_levels)

func zoom_out(n_levels=null):
	if cam and is_instance_valid(cam):
		cam.zoom_dir("out", n_levels)


####################################################################
# focus

var pof_group = "pofs"
var poa_group = "poas"
var poi_group = "pois"

func update_poas():
	if cam and is_instance_valid(cam):
		cam.update_poas()

func update_pofs():
	if cam and is_instance_valid(cam):
		# currently also called in cam._process() ...?
		cam.update_pofs()

func update_pois():
	if cam and is_instance_valid(cam):
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


# func _input(event):
# 	if Trolls.is_event(event, "zoom_in"):
# 		if cam and is_instance_valid(cam):
# 			cam.zoom_dir("in")
# 	elif Trolls.is_event(event, "zoom_out"):
# 		if cam and is_instance_valid(cam):
# 			cam.zoom_dir("out")
# 	if Trolls.is_action(event):
# 		if cam and is_instance_valid(cam):
# 			# freezeframe("shake-watch", 0.2, 1.5)
# 			cam.inc_trauma(0.1)
