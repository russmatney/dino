extends Camera2D

enum cam_mode { FOLLOW, ANCHOR, FOLLOW_AND_POIS }
@export var mode: cam_mode = cam_mode.FOLLOW

@export var follow_group: String = "player"
@export var anchor_group: String = "camera_anchor"
@export var poi_group: String = Cam.poi_group
@export var pof_group: String = Cam.pof_group

var following
var current_anchor

var poi_follows = []
var pof_follows = []

var poi_following_distance = 400
var pof_following_distance = 400

var zoom_level = 1.0
var min_zoom_level = 1.0
var max_zoom_level = 10.0
var zoom_increment = 0.1
var zoom_offset: float = 500.0
var zoom_offset_previous : float
var zoom_offset_increment = 150.0
var zoom_tween_duration = 0.1

###########################################################################
# ready

var original_offset
var original_rotation


func _ready():
	original_offset = offset
	original_rotation = rotation
	zoom_offset_previous = zoom_offset

	# otherwise we can't do a rotational screenshake
	# let's hope the camera parent doesn't need to rotate...
	set_ignore_rotation(false)

	if mode == cam_mode.FOLLOW_AND_POIS:
		if poi_group:
			update_pois()
		elif pof_group:
			update_pofs()

	update_window_size()
	# TODO recreate this? what to subscribe too?
	# var _x = get_tree().connect("screen_resized",Callable(self,"update_window_size"))

	if not following:
		find_node_to_follow()

###########################################################################
# window size updates

var window_size
func update_window_size():
	window_size = DisplayServer.window_get_size()

###########################################################################
# process


func _process(delta):
	match mode:
		cam_mode.FOLLOW:
			if not following:
				find_node_to_follow()
		cam_mode.ANCHOR:
			if not following:
				find_node_to_follow()
			else:
				if is_instance_valid(following):
					attach_to_nearest_anchor()
				else:
					following = null
		cam_mode.FOLLOW_AND_POIS:
			if not following:
				find_node_to_follow()

			update_pois()
			update_pofs()
			update_focus()


###########################################################################
# physics_process


func _physics_process(delta):
	process_shake(delta)


###########################################################################
# input


func _input(event):
	if Trolley.is_event(event, "zoom_in"):
		zoom_dir("in")
	elif Trolley.is_event(event, "zoom_out"):
		zoom_dir("out")

	if Trolley.is_action(event):
		# Cam.freezeframe("shake-watch", 0.2, 1.5)
		# inc_trauma(1.0)
		# inc_trauma(0.3)
		inc_trauma(0.5)
		# inc_trauma(1.0)


###########################################################################
# zoom

func calc_zoom_offset_increment():
	return zoom_offset_increment + zoom_offset * 0.1

func zoom_dir(dir, n_levels = null):
	zoom_offset_previous = zoom_offset
	var inc
	var offset_inc

	if not n_levels and zoom_level > 2:
		n_levels = 2
	elif not n_levels:
		n_levels = 1

	match dir:
		"in":
			zoom_level += zoom_increment * n_levels
			zoom_offset += calc_zoom_offset_increment() * n_levels
		"out":
			zoom_level -= zoom_increment * n_levels
			zoom_offset -= calc_zoom_offset_increment() * n_levels
		"to":
			zoom_level = n_levels
			zoom_offset = calc_zoom_offset_increment() * n_levels

	if zoom_level >= max_zoom_level or zoom_level <= min_zoom_level:
		Cam.prn("Zoom min/max hit. level: ", zoom_level, " offset: ", zoom_offset)

	Cam.prn("[LOG] Zoom updated level:: ", zoom_level, " offset: ", zoom_offset)

	match mode:
		cam_mode.FOLLOW:
			update_zoom()
		cam_mode.ANCHOR:
			update_zoom()
		cam_mode.FOLLOW_AND_POIS:
			# updated via _process
			pass

###########################################################################
# update zoom

var zoom_tween

func update_zoom():
	zoom_level = clamp(zoom_level, min_zoom_level, max_zoom_level)
	zoom_tween = create_tween()
	var new_zoom = Vector2(zoom_level, zoom_level)
	zoom_tween.tween_property(self, "zoom", new_zoom, zoom_tween_duration).set_trans(Tween.TRANS_SINE).set_ease(
		Tween.EASE_OUT
	)

###########################################################################
# follow mode


func find_node_to_follow():
	var nodes = get_tree().get_nodes_in_group(follow_group)

	if nodes.size() > 1:
		Cam.prn("[WARN] Camera found multiple nodes to follow", nodes)

	if nodes.size() > 0:
		following = nodes[0]
		match mode:
			cam_mode.FOLLOW:
				Util.change_parent(self, following)
			cam_mode.FOLLOW_AND_POIS:
				Util.change_parent(self, following)
			cam_mode.ANCHOR:
				attach_to_nearest_anchor()

###########################################################################
# anchor mode

func attach_to_nearest_anchor():
	# assumes `following` is set as desired

	# find nearest anchor node, reparent to that
	var anchors = get_tree().get_nodes_in_group(anchor_group)
	if anchors.size() == 0:
		Cam.prn("[WARN] Camera found no anchor nodes, attaching to player")
		Util.change_parent(self, following)
	else:
		# TODO this may be too expensive to run per process-loop, there's likely an optimization...
		# maybe only run this when the player moves some distance?
		# or make it disable-able/only called from an autoload/at specific times

		# handling in case the player dies before here
		if is_instance_valid(following):
			var nearest_anchor = Util.nearest_node(following, anchors)
			if nearest_anchor != current_anchor:
				current_anchor = nearest_anchor
				Util.change_parent(self, current_anchor)
		else:
			following = null


###########################################################################
# update pofs/pois

# TODO how often should we check for more follows?
# maybe trigger via signal/singleton when adding new nodes
func update_pois():
	if poi_group:
		var all_pois = get_tree().get_nodes_in_group(poi_group)
		var nearby_pois = []

		if following:
			for poi in all_pois:
				var dist_vec = following.global_position - poi.global_position
				var dist_len = dist_vec.length()
				if dist_len <= poi_following_distance:
					nearby_pois.append(poi)

		if nearby_pois:
			poi_follows = nearby_pois


func update_pofs():
	if pof_group:
		var t = get_tree()
		if t:
			var pofs = t.get_nodes_in_group(pof_group)

			var to_focus = []
			for p in pofs:
				if p.has_method("pof_active"):
					if p.pof_active():
						to_focus.append(p)
				else:
					to_focus.append(p)

			pof_follows = to_focus

###########################################################################
# zoom in pof/poi mode

func build_focuses():
	if len(pof_follows) == 0 and not following:
		return []

	var focuses = []

	# TODO favor the `following` (player) position more
	focuses.append(following)
	focuses.append_array(pof_follows)
	# TODO favor pois based checked importance * proximity
	focuses.append_array(poi_follows)

	return focuses

func update_focus():
	# adjusts the offset and zoom based on following, pofs, and pois
	var focuses = build_focuses()
	if len(focuses) == 0:
		return

	var center = Vector2.ZERO

	var max_left
	var max_right
	var max_top
	var max_bottom

	for obj in focuses:
		center += obj.global_position

		if max_left == null:
			max_left = obj.global_position.x
		if max_right == null:
			max_right = obj.global_position.x
		if max_top == null:
			max_top = obj.global_position.y
		if max_bottom == null:
			max_bottom = obj.global_position.y

		if obj.global_position.x < max_left:
			max_left = obj.global_position.x
		if obj.global_position.x > max_right:
			max_right = obj.global_position.x
		if obj.global_position.y < max_top:
			max_top = obj.global_position.y
		if obj.global_position.y > max_bottom:
			max_bottom = obj.global_position.y

	var merged_rect = Rect2()
	merged_rect.position = Vector2(max_left, max_top)
	merged_rect.end = Vector2(max_right, max_bottom)

	# center camera on merged rect
	self.global_position = merged_rect.get_center()

	update_zoom_level_for_bounds(merged_rect)

	zoom_level = int(clamp(zoom_level, min_zoom_level, max_zoom_level))
	Hood.debug_label("calced+clamped zoom level", str("calced zoom level: ", zoom_level))
	clamp_zoom_offset()

	Hood.debug_label("zoom offset", str("zoom offset: ", zoom_offset))

	update_zoom()

	Hood.debug_label("final zoom level", str("final zoom level: ", zoom_level))
	Hood.debug_label("cam target pos", str("cam target pos: ", get_target_position()))

func clamp_zoom_offset():
	# prevent zoom offset moving beyond clamp
	if zoom_level == min_zoom_level and zoom_offset < zoom_offset_previous:
		zoom_offset = zoom_offset_previous
	elif zoom_level == max_zoom_level and zoom_offset > zoom_offset_previous:
		zoom_offset = zoom_offset_previous

# TODO per zoom level margins?
var zoom_rect_min_margin = 50

func update_zoom_level_for_bounds(focuses_rect):
	Hood.debug_label("focuses rect", str("focuses rect: ", focuses_rect, " end: ", focuses_rect.end))
	# print("pt_a: ", pt_a)
	# print("pt_b: ", pt_b)
	var x = focuses_rect.size.x
	var y = focuses_rect.size.y
	Hood.debug_label("frect size", str("frect size: ", focuses_rect.size))
	Hood.debug_label("window size", str("window size: ", window_size))
	var vp_size = get_viewport().size
	Hood.debug_label("viewport size", str("viewport size: ", vp_size))

	var frect_over_viewport_x = vp_size.x / focuses_rect.size.x
	var frect_over_viewport_y = vp_size.y / focuses_rect.size.y
	Hood.debug_label("viewport frect x ratio", str("frect/viewport x: ", frect_over_viewport_x))
	Hood.debug_label("viewport frect y ratio", str("frect/viewport y: ", frect_over_viewport_y))

	# zoom = viewport / desired_rect

	var x_factor = focuses_rect.size.x + zoom_rect_min_margin
	var y_factor = focuses_rect.size.y + zoom_rect_min_margin
	var x_ratio = vp_size.x / x_factor
	var y_ratio = vp_size.y / y_factor
	zoom_level = min(x_ratio, y_ratio)

	Hood.debug_label("frect x min margin", str("x factor: ", x_factor))
	Hood.debug_label("frect y min margin", str("y factor: ", y_factor))
	Hood.debug_label("final x ratio", str("x ratio: ", x_ratio))
	Hood.debug_label("final y ratio", str("y ratio: ", y_ratio))



###########################################################################
# screenshake

# https://youtu.be/tu-Qe66AvtY?t=260
var trauma = 0.0
var trauma_decrement_factor = 0.7

func inc_trauma(inc):
	trauma += inc
	trauma = clamp(trauma, 0.0, 1.0)

var shake_offset
var shake_rotation
var trans_noise_ctx
var rot_noise_ctx

func screenshake_reset():
	shake_offset = null
	shake_rotation = null
	trans_noise_ctx = null
	rot_noise_ctx = null
	# These 'originals' could use a better name
	# and may need to be updated by hand if an external something or other wants camera control
	self.offset = original_offset
	self.rotation = original_rotation

func process_shake(delta):
	if trauma > 0:
		# Cam.prn("[CAM] Trauma: ", trauma)
		trauma -= trauma_decrement_factor * delta
		trauma = clamp(trauma, 0.0, 1.0)
		if trauma == 0.0:
			screenshake_reset()
		else:
			if trans_noise_ctx == null:
				trans_noise_ctx = {"noise": new_noise(noise_inputs), "t": 0}
			if rot_noise_ctx == null:
				noise_inputs["seed"] += randi()
				rot_noise_ctx = {"noise": new_noise(noise_inputs), "t": 0}
			screenshake_translational(trans_noise_ctx, delta)
			screenshake_rotational(rot_noise_ctx, delta)
	if shake_offset:
		self.offset = original_offset + shake_offset
	if shake_rotation:
		self.rotation = original_rotation + shake_rotation

var noise_inputs = {
	"seed": 4,
	"octaves": 5.0,
	"frequency": 1.0/5.0,
	"gain": 0.8,
	"lacunarity": 4.0,
}

func new_noise(inputs):
	var noise = FastNoiseLite.new()
	noise.seed = inputs["seed"]
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.fractal_octaves = inputs["octaves"]
	noise.fractal_gain = inputs["gain"]
	noise.fractal_lacunarity = inputs["lacunarity"]
	noise.frequency = inputs["frequency"]
	return noise

func next_noise_factor(noise_ctx, delta):
	noise_ctx["t"] = delta + noise_ctx["t"]
	noise_ctx["factor"] = noise_ctx["noise"].get_noise_1d(noise_ctx["t"])

var max_shake_offset = 100
var max_shake_rotation = PI / 8

func screenshake_translational(noise_ctx, delta):
	var max_offset = Vector2(max_shake_offset, max_shake_offset)
	var shake = trauma * trauma
	next_noise_factor(noise_ctx, delta)
	shake_offset = max_offset * shake * noise_ctx["factor"]

func screenshake_rotational(noise_ctx, delta):
	var shake = trauma * trauma
	next_noise_factor(noise_ctx, delta)
	shake_rotation = max_shake_rotation * shake * noise_ctx["factor"]
