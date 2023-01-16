extends Camera2D

enum cam_mode { FOLLOW, ANCHOR, FOLLOW_AND_POIS }
export(cam_mode) var mode = cam_mode.FOLLOW

export(String) var follow_group = "player"
export(String) var anchor_group = "camera_anchor"
export(String) var poi_group = "poi"
export(String) var pof_group = "pof"

var following
var current_anchor

var poi_follows = []
var pof_follows = []
var window_size = OS.window_size
var poi_following_distance = 400
var pof_following_distance = 400

var zoom_level = 1.0
var zoom_increment = 0.1
var zoom_offset = 500
var zoom_offset_previous = 500
var zoom_offset_increment = 50
var zoom_duration = 0.2
var min_zoom = 0.5
var max_zoom = 5.0


###########################################################################
# ready

func _ready():
	original_offset = offset
	original_rotation = rotation

	if mode == cam_mode.FOLLOW_AND_POIS:
		if poi_group:
			update_pois()
		elif pof_group:
			update_pofs()

	update_window_size()
	var _x = get_tree().connect("screen_resized", self, "update_window_size")

	if not following:
		find_node_to_follow()


###########################################################################
# process


func _process(_delta):
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

			# TODO how often do we update this?
			update_pois()
			update_pofs()

			center_pois()

###########################################################################
# input

func _input(event):
	if Trolley.is_event(event, "zoom_in"):
		print("zoom in!")
		zoom_level -= zoom_increment
		zoom_offset_previous = zoom_offset
		zoom_offset -= zoom_offset_increment
		match mode:
			cam_mode.FOLLOW:
				update_zoom()
			cam_mode.ANCHOR:
				pass
			cam_mode.FOLLOW_AND_POIS:
				pass
	elif Trolley.is_event(event, "zoom_out"):
		print("zoom out!")
		zoom_level += zoom_increment
		zoom_offset_previous = zoom_offset
		zoom_offset += zoom_offset_increment
		match mode:
			cam_mode.FOLLOW:
				update_zoom()
			cam_mode.ANCHOR:
				pass
			cam_mode.FOLLOW_AND_POIS:
				pass

###########################################################################
# zoom

func update_zoom():
	print("updating zoom: ", zoom_level)
	zoom_level = clamp(zoom_level, min_zoom, max_zoom)
	print("setting zoom: ", zoom_level)
	self.zoom = Vector2(zoom_level, zoom_level)

###########################################################################
# screenshake

var shake_amplitude = 10
var shake_variance = 10
var shake_duration = 0.2
var shake_loops = 1
var original_offset
var original_rotation


func screenshake(opts = {}):
	var lps = opts.get("loops", shake_loops)
	var vary = opts.get("variance", shake_variance)
	var amp = opts.get("amplitude", shake_amplitude)
	var dur = opts.get("duration", shake_duration)

	var tween = create_tween()
	tween.set_loops(lps)

	# TODO finish wip rotational shake feat
	# rotational
	# var rot_diff = PI + (PI * 0.10 * rand_range(-vary, vary))

	# translational
	var rand = Vector2(rand_range(-vary, vary), rand_range(-vary, vary))
	var diff = Vector2(sign(rand.x) * amp + rand.x, sign(rand.y) * amp + rand.y)

	tween.tween_property(self, "offset", offset + diff, dur).set_trans(Tween.TRANS_SINE).set_ease(
		Tween.EASE_IN_OUT
	)
	# tween.parallel().tween_property(self, "rotation", rotation + rot_diff, dur).set_trans(Tween.TRANS_SINE).set_ease(
	# 	Tween.EASE_IN_OUT
	# )

	# reset
	tween.tween_property(self, "offset", original_offset, dur).set_trans(Tween.TRANS_SINE).set_ease(
		Tween.EASE_IN_OUT
	)
	# tween.parallel().tween_property(self, "rotation", original_rotation, dur).set_trans(Tween.TRANS_SINE).set_ease(
	# 	Tween.EASE_IN_OUT
	# )


###########################################################################
# follow mode


func find_node_to_follow():
	var nodes = get_tree().get_nodes_in_group(follow_group)

	if nodes.size() > 1:
		print("[WARN] Camera found multiple nodes to follow", nodes)

	if nodes.size() > 0:
		following = nodes[0]
		match mode:
			cam_mode.FOLLOW:
				Util.reparent(self, following)
			cam_mode.FOLLOW_AND_POIS:
				Util.reparent(self, following)
			cam_mode.ANCHOR:
				attach_to_nearest_anchor()


###########################################################################
# anchor mode


func attach_to_nearest_anchor():
	# assumes `following` is set as desired

	# find nearest anchor node, reparent to that
	var anchors = get_tree().get_nodes_in_group(anchor_group)
	if anchors.size() == 0:
		print("[WARN] Camera found no anchor nodes, attaching to player")
		Util.reparent(self, following)
	else:
		# TODO this may be too expensive to run per process-loop, there's likely an optimization...
		# maybe only run this when the player moves some distance?
		# or make it disable-able/only called from an autoload/at specific times

		# handling in case the player dies before here
		if is_instance_valid(following):
			var nearest_anchor = Util.nearest_node(following, anchors)
			if nearest_anchor != current_anchor:
				current_anchor = nearest_anchor
				Util.reparent(self, current_anchor)
		else:
			following = null


###########################################################################
# pof/poi mode


func update_window_size():
	window_size = OS.window_size


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
		pof_follows = get_tree().get_nodes_in_group(pof_group)

func zoom_factor_for_bounds(pt_a, pt_b):
	var x = abs(pt_a.x - pt_b.x)
	var y = abs(pt_a.y - pt_b.y)
	var zoom_factor1 = (x + zoom_offset) / window_size.x
	var zoom_factor2 = (y + zoom_offset) / window_size.y
	var zoom_factor = clamp(max(zoom_factor1, zoom_factor2), min_zoom, max_zoom)

	# prevent zooming beyond clamp
	if zoom_factor == min_zoom and zoom_offset < zoom_offset_previous:
		# TODO a bit bouncy, but maybe that's fine
		zoom_offset = zoom_offset_previous
	elif zoom_factor == max_zoom and zoom_offset > zoom_offset_previous:
		zoom_offset = zoom_offset_previous
	return zoom_factor


func center_pois():
	if pof_follows and following:
		# TODO favor the following (player) position more
		var focuses = pof_follows.append(following)

		poi_follows

		# TODO pois have importance and proximity
		# that should feed into the weighting

		var center = Vector2.ZERO

		var max_left
		var max_right
		var max_top
		var max_bottom

		for obj in pof_follows:
			center += obj.global_position

			if not max_left:
				max_left = obj.global_position.x
			if not max_right:
				max_right = obj.global_position.x
			if not max_top:
				max_top = obj.global_position.y
			if not max_bottom:
				max_bottom = obj.global_position.y

			if obj.global_position.x < max_left:
				max_left = obj.global_position.x
			if obj.global_position.x > max_right:
				max_right = obj.global_position.x
			if obj.global_position.y < max_top:
				max_top = obj.global_position.y
			if obj.global_position.y > max_bottom:
				max_bottom = obj.global_position.y

		center = center / pof_follows.size()
		self.global_position = center

		zoom_level = zoom_factor_for_bounds(Vector2(max_right, max_bottom), Vector2(max_left, max_top))
		update_zoom()
