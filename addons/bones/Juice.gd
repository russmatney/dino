@tool
extends Node
class_name J

## static ###############################################

static func slowmo_start():
	Debug.notif("Slooooooow mooooootion")
	Juice.start_slowmo("basic_slowmo", 0.3)

static func slowmo_stop():
	Debug.notif("Back to full speed")
	Juice.stop_slowmo("basic_slowmo")


## process ####################################################

func _process(delta):
	process_shake(delta)

## slowmo #############################################################

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


## freezeframe #############################################################

# could refactor into opts-based map apis

# freezeframes called in parallel may compete/reset eachother
# maybe register_slowmo is a viable workaround?
func freezeframe(opts={}):
	var nm = opts.get("name", "freezeframe")
	var time_scale = opts.get("time_scale", 0.5)
	var duration = opts.get("duration", 0.2)
	var trauma = opts.get("trauma", 0.1)
	inc_trauma(trauma)
	Juice.start_slowmo(nm, time_scale)
	await get_tree().create_timer(duration, true, false, true).timeout
	Juice.stop_slowmo(nm)

func hitstop(opts={}):
	U.ensure_default(opts, "name", "hitstop")
	U.ensure_default(opts, "time_scale", 0.5)
	U.ensure_default(opts, "duration", 0.2)
	U.ensure_default(opts, "trauma", 0.1)
	freezeframe(opts)


## screenshake #############################################################

# https://youtu.be/tu-Qe66AvtY?t=260
var trauma = 0.0
var trauma_decrement_factor = 0.7

func inc_trauma(inc=0.1):
	trauma += inc
	trauma = clamp(trauma, 0.0, 1.0)

func set_trauma(val):
	trauma = clamp(val, 0.0, 1.0)

func screenshake(trauma = 0.3):
	inc_trauma(trauma)

func screenshake_cancel():
	Log.warn("screenshake cancel not impled")


var shake_offset
var shake_rotation
var trans_noise_ctx
var rot_noise_ctx

var original_offset = Vector2()
var original_rotation = 0

# func _ready():
# 	var cam = current_camera()
# 	if cam:
# 		# TODO update to hook into camera creation/is_current
# 		original_offset = cam.offset
# 		original_rotation = cam.rotation

func current_camera():
	var cam = get_viewport().get_camera_2d()
	if cam and is_instance_valid(cam):
		return cam

func current_pcam_host():
	var cam = current_camera()
	if cam:
		for ch in cam.get_children():
			pass
			# if ch is PhantomCameraHost:
			# 	return ch

func current_pcam():
	var pcam
	var host = current_pcam_host()
	if host:
		pcam = host.get_active_pcam()

	if pcam and is_instance_valid(pcam):
		return pcam

func screenshake_reset():
	shake_offset = null
	shake_rotation = null
	trans_noise_ctx = null
	rot_noise_ctx = null

	var cam = current_camera()
	var pcam = current_pcam()
	if cam:
		cam.offset = original_offset
	if pcam:
		pcam.rotation = original_rotation

func process_shake(delta):
	if trauma > 0:
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

	var cam = current_camera()
	var pcam = current_pcam()
	if cam and shake_offset:
		cam.offset = original_offset + shake_offset
	if pcam and shake_rotation:
		pcam.set_rotation(original_rotation + shake_rotation)

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
