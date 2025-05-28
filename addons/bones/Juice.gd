@tool
extends Node
class_name J

## static ###############################################

static func slowmo_start() -> void:
	Debug.notif("Slooooooow mooooootion")
	Juice.start_slowmo("basic_slowmo", 0.3)

static func slowmo_stop() -> void:
	Debug.notif("Back to full speed")
	Juice.stop_slowmo("basic_slowmo")


## process ####################################################

func _process(delta: float) -> void:
	process_shake(delta)

## slowmo #############################################################

signal slowmo_stopped(label: String)

# ordered dict?
var slowmos := []
var slowmo_scales := {}


func start_slowmo(label: String, scale: float = 0.5) -> void:
	# Debug.debug_label("[CAM] start slowmo: ", label, " scale: ", scale)
	slowmos.append(label)
	slowmo_scales[label] = scale
	Engine.time_scale = scale

func stop_slowmo(label: String) -> void:
	# Debug.debug_label("[CAM] stop slowmo: ", label)
	slowmos.erase(label)
	slowmo_scales.erase(label)
	slowmo_stopped.emit(label)
	resume_slowmo()

func clear_all_slowmos() -> void:
	slowmos.clear()
	slowmo_scales.clear()
	Engine.time_scale = 1.0

# resumes normal time if no slowmos remain
func resume_slowmo() -> void:
	if slowmos.is_empty() or slowmo_scales.is_empty():
		Engine.time_scale = 1.0
		return

	var l: String = slowmos[0]
	# maybe a bug here if two targets are destroyed at the same time
	if l in slowmo_scales:
		var scale: float = slowmo_scales[l]
		Engine.time_scale = scale


## freezeframe #############################################################

# could refactor into opts-based map apis

# freezeframes called in parallel may compete/reset eachother
# maybe register_slowmo is a viable workaround?
func freezeframe(opts: Dictionary = {}) -> void:
	var nm: String = opts.get("name", "freezeframe")
	var time_scale: float = opts.get("time_scale", 0.5)
	var duration: float = opts.get("duration", 0.2)
	var tra: float = opts.get("trauma", 0.1)
	inc_trauma(tra)
	Juice.start_slowmo(nm, time_scale)
	await get_tree().create_timer(duration, true, false, true).timeout
	Juice.stop_slowmo(nm)

func hitstop(opts: Dictionary = {}) -> void:
	U.ensure_default(opts, "name", "hitstop")
	U.ensure_default(opts, "time_scale", 0.5)
	U.ensure_default(opts, "duration", 0.2)
	U.ensure_default(opts, "trauma", 0.1)
	freezeframe(opts)


## screenshake #############################################################

# https://youtu.be/tu-Qe66AvtY?t=260
var trauma := 0.0
var trauma_decrement_factor := 0.7

func inc_trauma(inc: float = 0.1) -> void:
	trauma += inc
	trauma = clamp(trauma, 0.0, 1.0)

func set_trauma(val: float) -> void:
	trauma = clamp(val, 0.0, 1.0)

func screenshake(tra: float = 0.3) -> void:
	inc_trauma(tra)

func screenshake_cancel() -> void:
	Log.warn("screenshake cancel not impled")


var shake_offset: Vector2
var shake_rotation: float
var trans_noise_ctx: Dictionary
var rot_noise_ctx: Dictionary

func current_camera() -> Camera2D:
	var cam := get_viewport().get_camera_2d()
	if cam and is_instance_valid(cam):
		return cam
	return

func current_pcam_host() -> Camera2D:
	var cam := current_camera()
	if cam:
		for ch in cam.get_children():
			pass
			# TODO how to avoid phantomCamera dep? or do we just add it?
			# if ch is PhantomCameraHost:
			# 	return ch
	return


func current_pcam() -> Camera2D:
	var pcam: Camera2D
	var host := current_pcam_host()
	if host:
		@warning_ignore("unsafe_method_access")
		pcam = host.get_active_pcam()

	if pcam and is_instance_valid(pcam):
		return pcam
	return

func screenshake_reset() -> void:
	shake_offset = Vector2.ZERO
	shake_rotation = 0.0
	trans_noise_ctx = {}
	rot_noise_ctx = {}

	var pcam := current_pcam()
	if pcam:
		@warning_ignore("unsafe_method_access")
		pcam.emit_noise(Transform2D())

func process_shake(delta: float) -> void:
	if trauma > 0:
		trauma -= trauma_decrement_factor * delta
		trauma = clamp(trauma, 0.0, 1.0)
		if trauma == 0.0:
			screenshake_reset()
		else:
			if trans_noise_ctx == {}:
				trans_noise_ctx = {"noise": new_noise(noise_inputs), "t": 0}
			if rot_noise_ctx == {}:
				noise_inputs["seed"] += randi()
				rot_noise_ctx = {"noise": new_noise(noise_inputs), "t": 0}
			screenshake_translational(trans_noise_ctx, delta)
			screenshake_rotational(rot_noise_ctx, delta)

	# TODO don't fetch cams every frame
	var pcam := current_pcam()
	if pcam and shake_rotation != 0.0:
		var transform := Transform2D(shake_rotation, shake_offset)
		@warning_ignore("unsafe_method_access")
		pcam.emit_noise(transform)

var noise_inputs := {
	"seed": 4,
	"octaves": 5.0,
	"frequency": 1.0/5.0,
	"gain": 0.8,
	"lacunarity": 4.0,
}

func new_noise(inputs: Dictionary) -> FastNoiseLite:
	var noise := FastNoiseLite.new()
	noise.seed = inputs["seed"]
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.fractal_octaves = inputs["octaves"]
	noise.fractal_gain = inputs["gain"]
	noise.fractal_lacunarity = inputs["lacunarity"]
	noise.frequency = inputs["frequency"]
	return noise

func next_noise_factor(noise_ctx: Dictionary, delta: float) -> void:
	noise_ctx["t"] = delta + noise_ctx["t"]
	@warning_ignore("unsafe_method_access")
	noise_ctx["factor"] = noise_ctx["noise"].get_noise_1d(noise_ctx["t"])

var max_shake_offset := 100.0
var max_shake_rotation := PI / 8.0

func screenshake_translational(noise_ctx: Dictionary, delta: float) -> void:
	var max_offset := Vector2(max_shake_offset, max_shake_offset)
	var shake := trauma * trauma
	next_noise_factor(noise_ctx, delta)
	shake_offset = max_offset * shake * noise_ctx["factor"]

func screenshake_rotational(noise_ctx: Dictionary, delta: float) -> void:
	var shake := trauma * trauma
	next_noise_factor(noise_ctx, delta)
	shake_rotation = max_shake_rotation * shake * noise_ctx["factor"]
