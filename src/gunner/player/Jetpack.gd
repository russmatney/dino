extends State

var is_jetting

var jet_boost_ramp
var jet_boost_levels = [
	# depends checked order, should be sorted by descending "time"
	{
		"time": 1.0,
		"boost": 1.0,
	},
	{
		"time": 0.5,
		"boost": 0.7,
	},
	{
		"time": 0.25,
		"boost": 0.4,
	},
	{
		"time": 0.0,
		"boost": 4.0,
		"boost_from_air": 3.3,
	}
]

var jet_boost_level


func jet_boost_factor(delta):
	jet_boost_ramp += delta
	for jbl in jet_boost_levels:
		if jet_boost_ramp > jbl["time"]:
			if "boost_from_air" in jbl:
				if not actor.is_on_floor():
					jet_boost_level = jbl
					return jbl["boost_from_air"]
			jet_boost_level = jbl
			return jbl["boost"]


var jet_sound_every = 1.1
var jet_sound_in


func enter(_ctx = {}):
	actor.anim.animation = "jetpack"
	is_jetting = true
	jet_boost_ramp = 0
	DJZ.play(DJZ.S.jet_boost)
	Cam.screenshake(0.2)

	jet_sound_in = jet_sound_every


func physics_process(delta):
	jet_sound_in -= delta
	if jet_sound_in <= 0:
		DJZ.play(DJZ.S.jet_boost)
		jet_sound_in = jet_sound_every
		Cam.screenshake(0.2)

	# TODO get_action_strength for shoulder buttons
	if Input.is_action_pressed("jetpack"):
		if not is_jetting:
			DJZ.interrupt(DJZ.S.jet_echo)
			if not actor.in_blue:
				DJZ.play(DJZ.S.jet_boost)
				jet_sound_in = jet_sound_every
			is_jetting = true
	else:
		DJZ.interrupt(DJZ.S.jet_boost)
		if is_jetting:
			DJZ.play(DJZ.S.jet_echo)
		jet_boost_ramp = 0
		is_jetting = false

	# and not actor.in_blue
	if is_jetting and not actor.is_dead:
		actor.jet_anim.set_visible(true)

		var boost_factor = jet_boost_factor(delta)

		if actor.in_red:
			boost_factor *= 2
		if actor.in_blue:
			boost_factor /= 8

		if boost_factor > 0.5:
			actor.jet_anim.animation = "all"
		else:
			actor.jet_anim.animation = "init"

		actor.velocity.y -= actor.jetpack_boost * boost_factor * delta
		actor.velocity.y += actor.gravity * delta / 4
		actor.velocity.y = clamp(actor.velocity.y, actor.max_jet_speed, actor.velocity.y)
	else:
		actor.jet_anim.set_visible(false)
		actor.velocity.y += actor.gravity * delta

	if actor.move_dir:
		actor.velocity.x = actor.air_speed * actor.move_dir.x
	else:
		actor.velocity.x = actor.velocity.x * 0.9 * delta

	actor.set_velocity(actor.velocity)
	actor.move_and_slide()

	if not actor.firing:
		actor.update_facing()

	if not is_jetting and actor.is_on_floor():
		machine.transit("Idle")

	if not is_jetting and actor.velocity.y > 0:
		machine.transit("Fall")
