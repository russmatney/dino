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

var poi_following_distance = 150

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

	Debug.debug_toggled.connect(_on_debug_toggled)

func _on_debug_toggled(debugging):
	if debugging:
		print("debugging cam2d!")
	queue_redraw()

###########################################################################
# window size updates

var window_size
func update_window_size():
	window_size = DisplayServer.window_get_size()

###########################################################################
# process


func _process(delta):
	Debug.debug_label("Window Size", window_size)
	var vp_size = get_viewport().size
	Debug.debug_label("Viewport Size", vp_size)
	Debug.debug_label("Zoom Level", "[jump]", zoom_level, "[/jump]")
	Debug.debug_label("Zoom Offset", zoom_offset)
	Debug.debug_label("Cam Center", get_target_position())

	if Debug.debugging:
		queue_redraw()


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

			Debug.debug_label("pofs: ", pof_follows)
			Debug.debug_label("pois: ", poi_follows)



###########################################################################
# physics_process


func _physics_process(delta):
	process_shake(delta)



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
		Debug.prn("Zoom min/max hit. level: ", zoom_level, " offset: ", zoom_offset)

	# TODO Debug throttle/debounce log option
	# Debug.prn("[LOG] Zoom updated level:: ", zoom_level, " offset: ", zoom_offset)

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
		Debug.warn("Camera found multiple nodes to follow", nodes)

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
		Debug.warn("Camera found no anchor nodes, attaching to player")
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

# how often should we check for more follows?
# maybe trigger via signal/singleton when adding new nodes?
func update_pois():
	if poi_group:
		var all_pois = get_tree().get_nodes_in_group(poi_group)

		var active_pois = []
		for p in all_pois:
			if p.has_method("is_active"):
				if p.is_active():
					active_pois.append(p)
			else:
				active_pois.append(p)

		var nearby_pois = active_pois
		# var nearby_pois = []

		# if following:
		# 	for poi in active_pois:
		# 		var dist_vec = following.global_position - poi.global_position
		# 		var dist_len = dist_vec.length()
		# 		if dist_len <= poi_following_distance:
		# 			nearby_pois.append(poi)

		if nearby_pois:
			poi_follows = nearby_pois


func update_pofs():
	if pof_group:
		var t = get_tree()
		if t:
			var pofs = t.get_nodes_in_group(pof_group)

			var to_focus = []
			for p in pofs:
				if p.has_method("is_active"):
					if p.is_active():
						to_focus.append(p)
				else:
					to_focus.append(p)
			pof_follows = to_focus

###########################################################################
# zoom in pof/poi mode


func build_focuses():
	if len(pof_follows) == 0 and not following:
		return []

	var fcses = []

	# TODO favor the `following` (player) position more
	fcses.append(following)
	fcses.append_array(pof_follows)
	# TODO favor pois based checked importance * proximity
	fcses.append_array(poi_follows)

	return fcses

var focuses = []
var focuses_rect = Rect2()

func update_focus():
	# adjusts the offset and zoom based on following, pofs, and pois
	focuses = build_focuses()
	if len(focuses) == 0:
		return

	var center = Vector2.ZERO

	var max_left
	var max_right
	var max_top
	var max_bottom

	# TODO refactor into reduce
	for obj in focuses:
		var obj_pos
		if obj.is_in_group(poi_group):
			var weighted_dist = weighted_poi_offset(obj)
			# ignore poi if it's so far that our proximity is zero
			if weighted_dist.length() > 0:
				var poi_weighted_pos = obj.global_position - weighted_dist
				obj_pos = poi_weighted_pos
		elif obj.is_in_group(pof_group) and obj != following:
			obj_pos = obj.global_position - pof_offset(obj)
		else:
			obj_pos = obj.global_position

		if obj_pos != null:
			center += obj_pos

			if max_left == null or obj_pos.x < max_left:
				max_left = obj_pos.x
			if max_right == null or obj_pos.x > max_right:
				max_right = obj_pos.x
			if max_top == null or obj_pos.y < max_top:
				max_top = obj_pos.y
			if max_bottom == null or obj_pos.y > max_bottom:
				max_bottom = obj_pos.y

	focuses_rect = Rect2()
	focuses_rect.position = Vector2(max_left, max_top)
	focuses_rect.end = Vector2(max_right, max_bottom)

	# center camera on merged rect
	self.global_position = focuses_rect.get_center()

	update_zoom_level_for_bounds()

	zoom_level = clamp(zoom_level, min_zoom_level, max_zoom_level)
	clamp_zoom_offset()

	update_zoom()

func clamp_zoom_offset():
	# prevent zoom offset moving beyond clamp
	if zoom_level == min_zoom_level and zoom_offset < zoom_offset_previous:
		zoom_offset = zoom_offset_previous
	elif zoom_level == max_zoom_level and zoom_offset > zoom_offset_previous:
		zoom_offset = zoom_offset_previous

# TODO per zoom level margins?
var zoom_rect_min = 50
var zoom_min_margin = 50

## Attempts to determine a new zoom based on the passed rectangle of pofs
## camera2d zoom ~= viewport.size / desired_rect.size
func update_zoom_level_for_bounds():
	var vp_size = get_viewport().size

	Debug.debug_label("POF Rect", focuses_rect)

	var x = focuses_rect.size.x
	var y = focuses_rect.size.y
	var x_factor = max(focuses_rect.size.x, zoom_rect_min) + zoom_min_margin
	var y_factor = max(focuses_rect.size.y, zoom_rect_min) + zoom_min_margin
	var x_ratio = vp_size.x / x_factor
	var y_ratio = vp_size.y / y_factor
	zoom_level = min(x_ratio, y_ratio)


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
		Debug.debug_label("[CAM] Trauma: ", trauma)
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

################################################################
# debug

# TODO scrolling could move this min/max window

var pof_max = Vector2(100.0, 80.0)

## How much should we move the pof towards the player?
func pof_offset(pof) -> Vector2:
	var v_diff = pof.global_position - following.global_position
	var offset = Vector2()

	if abs(v_diff.x) < pof_max.x:
		offset.x = 0
	elif v_diff.x < 0:
		offset.x = v_diff.x + pof_max.x
	elif v_diff.x > 0:
		offset.x = v_diff.x - pof_max.x

	if abs(v_diff.y) < pof_max.y:
		offset.y = 0
	elif v_diff.y < 0:
		offset.y = v_diff.y + pof_max.y
	elif v_diff.y > 0:
		offset.y = v_diff.y - pof_max.y

	return offset

var proximity_max = 200.0
var proximity_min = 100.0

func weighted_poi_offset(poi) -> Vector2:
	var poi_diff = poi.global_position - following.global_position
	var poi_dist = poi_diff.length()

	var proximity # [0,1]
	if poi_dist > proximity_max:
		proximity = 0.0
	elif poi_dist < proximity_min:
		proximity = 1.0
	else:
		proximity = (poi_dist - proximity_min) / (proximity_max-proximity_min)

	var importance # [0,1]
	if poi.has_method("get_importance"):
		importance = poi.get_importance()
	else:
		importance = 0.5

	# invert vals: more important/proximal means smaller poi_contib
	# we want to focus MORE on the important thing, and this value pushes
	# the focused point away from the poi's position
	# (and less on the player)
	return poi_diff * (1 - importance) * proximity

var debug_font = preload("res://addons/core/assets/fonts/at01.ttf")
func _draw():
	if Debug.debugging:
		var player_pos = following.global_position - get_target_position()

		for p in focuses:
			var pos = p.global_position - get_target_position()
			draw_circle(pos, 2.0, Color.AQUAMARINE)

			if p.is_in_group(poi_group):
				var weighted_dist = weighted_poi_offset(p)
				var poi_weighted_pos = p.global_position - weighted_dist - get_target_position()
				var dist_from_player = poi_weighted_pos - player_pos

				var s = str(round(dist_from_player.length()), "\n")
				s += str(round(poi_weighted_pos.x), ",", round(poi_weighted_pos.y), "\n")

				draw_multiline_string(debug_font, poi_weighted_pos, s)
				draw_circle(poi_weighted_pos, 3.0, Color.AQUAMARINE)

			if p.is_in_group(pof_group) and p != following:
				var dist = pof_offset(p)
				var pof_pos = p.global_position - dist - get_target_position()
				var dist_from_player = pof_pos - player_pos

				var s = str(round(dist_from_player.length()), "\n")
				s += str(round(pof_pos.x), ",", round(pof_pos.y), "\n")

				draw_multiline_string(debug_font, pof_pos, s)
				draw_circle(pof_pos, 3.0, Color.AQUAMARINE)

			var diff = pos - player_pos
			if diff.length() != 0:
				var s = str("(", round(pos.x), ", ", round(pos.y), ")",
					"\n", round(diff.length()), " (", round(diff.x), ", ", round(diff.y), ")"
					)
				draw_multiline_string(debug_font, pos, s)
				draw_line(player_pos, pos, Color.MAGENTA, 1.0)

		var f_rect = focuses_rect
		f_rect.position -= get_target_position()
		draw_rect(f_rect, Color.CRIMSON, false, 2.0)
