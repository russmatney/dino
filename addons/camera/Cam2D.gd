extends Camera2D

enum cam_mode { FOLLOW, ANCHOR, FOLLOW_AND_POIS }
@export var mode: cam_mode = cam_mode.FOLLOW

@export var follow_group: String = "player"
@export var anchor_group: String = "camera_anchor"
@export var poi_group: String = "poi"
@export var pof_group: String = "pof"

var following
var current_anchor

var poi_follows = []
var pof_follows = []

var poi_following_distance = 400
var pof_following_distance = 400

var zoom_level = 1.0
var zoom_increment = 0.1
var zoom_offset = 500
var zoom_offset_previous
var zoom_offset_increment = 150
var zoom_duration = 0.2
var min_zoom = 0.2
var max_zoom = 4.0

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
	var _x = get_tree().connect("screen_resized",Callable(self,"update_window_size"))

	if not following:
		find_node_to_follow()


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

			# TODO how often do we update this?
			update_pois()
			update_pofs()

			center_pois()


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


func zoom_dir(dir, n = null):
	zoom_offset_previous = zoom_offset
	var inc
	var offset_inc

	if not n and zoom_level > 2:
		n = 2
	elif not n:
		n = 1

	match dir:
		"out":
			zoom_level += zoom_increment * n
			zoom_offset += zoom_offset_increment * n
		"in":
			zoom_level -= zoom_increment * n
			zoom_offset -= zoom_offset_increment * n

	print("<Cam> Zoom update. level: ", zoom_level, " offset: ", zoom_offset)

	match mode:
		cam_mode.FOLLOW:
			# untested
			update_zoom()
		cam_mode.ANCHOR:
			# untested
			update_zoom()
		cam_mode.FOLLOW_AND_POIS:
			# updated via _process
			pass


var zoom_tween


func update_zoom():
	zoom_level = clamp(zoom_level, min_zoom, max_zoom)
	zoom_tween = create_tween()
	var new_zoom = Vector2(zoom_level, zoom_level)
	zoom_tween.tween_property(self, "zoom", new_zoom, zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(
		Tween.EASE_OUT
	)


###########################################################################
# fractal screenshake

# https://youtu.be/tu-Qe66AvtY?t=260
var trauma = 0.0
var trauma_decrement_factor = 0.7


func inc_trauma(inc):
	trauma += inc
	trauma = clamp(trauma, 0.0, 1.0)
	# print("[CAM] Trauma: ", trauma)


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
		trauma -= trauma_decrement_factor * delta
		trauma = clamp(trauma, 0.0, 1.0)
		if trauma == 0.0:
			# print("[CAM] Trauma resetting: ", trauma)
			screenshake_reset()
		else:
			if not trans_noise_ctx:
				trans_noise_ctx = {"noise": new_noise(noise_inputs), "acc": 0}
			if not rot_noise_ctx:
				noise_inputs["seed"] += randi()
				rot_noise_ctx = {"noise": new_noise(noise_inputs), "acc": 0}
			screenshake_translational(trans_noise_ctx, delta)
			screenshake_rotational(rot_noise_ctx, delta)
	if shake_offset:
		self.offset = original_offset + shake_offset
	if shake_rotation:
		self.rotation = original_rotation + shake_rotation


var noise_inputs = {
	"seed": 4,
	"octaves": 5,
	"period": 5,
	"persistence": 0.8,
	"lacunarity": 4.0,
}


func new_noise(inputs):
	var noise = OpenSimplexNoise.new()
	noise.seed = inputs["seed"]
	noise.octaves = inputs["octaves"]
	noise.period = inputs["period"]
	noise.persistence = inputs["persistence"]
	noise.lacunarity = inputs["lacunarity"]
	return noise


func next_noise_factor(noise_ctx, delta):
	noise_ctx["acc"] = delta + noise_ctx["acc"]
	noise_ctx["factor"] = noise_ctx["noise"].get_noise_1d(noise_ctx["acc"])


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
		print("[WARN] Camera found no anchor nodes, attaching to player")
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
# pof/poi mode


func update_window_size():



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
	if not pof_follows and not following:
		return

	var focuses = []

	# TODO favor the `following` (player) position more
	focuses.append(following)
	focuses.append_array(pof_follows)
	# TODO favor pois based checked importance * proximity
	focuses.append_array(poi_follows)

	var center = Vector2.ZERO

	var max_left
	var max_right
	var max_top
	var max_bottom

	for obj in focuses:
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

	center = center / focuses.size()
	self.global_position = center

	zoom_level = zoom_factor_for_bounds(
		Vector2(max_right, max_bottom), Vector2(max_left, max_top)
	)
	update_zoom()
