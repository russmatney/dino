extends State

var jetpack_boost: int = 800
var max_jet_speed: int = -1200

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
	actor.anim.play("jetpack")
	is_jetting = true
	jet_boost_ramp = 0
	Sounds.play(Sounds.S.jet_boost)
	Juice.screenshake(0.2)

	jet_sound_in = jet_sound_every


func physics_process(delta):
	jet_sound_in -= delta
	if jet_sound_in <= 0:
		Sounds.play(Sounds.S.jet_boost)
		jet_sound_in = jet_sound_every
		Juice.screenshake(0.2)

	# get_action_strength for shoulder buttons
	if Input.is_action_pressed("jetpack"):
		if not is_jetting:
			Sounds.interrupt(Sounds.S.jet_echo)
			Sounds.play(Sounds.S.jet_boost)
			jet_sound_in = jet_sound_every
			is_jetting = true
	else:
		Sounds.interrupt(Sounds.S.jet_boost)
		if is_jetting:
			Sounds.play(Sounds.S.jet_echo)
		jet_boost_ramp = 0
		is_jetting = false

	if is_jetting and not actor.is_dead:
		if actor.jet_anim:
			actor.jet_anim.set_visible(true)

		var boost_factor = jet_boost_factor(delta)

		if actor.jet_anim:
			if boost_factor > 0.5:
				actor.jet_anim.play("all")
			else:
				actor.jet_anim.play("init")

		actor.velocity.y -= jetpack_boost * boost_factor * delta
		actor.velocity.y += actor.gravity * delta / 4
		actor.velocity.y = clamp(actor.velocity.y, max_jet_speed, actor.velocity.y)
	else:
		if actor.jet_anim:
			actor.jet_anim.set_visible(false)
		actor.velocity.y += actor.gravity * delta

	if actor.move_vector:
		actor.velocity.x = actor.air_speed * actor.move_vector.x * delta
	else:
		actor.velocity.x = actor.velocity.x * 0.9 * delta

	actor.set_velocity(actor.velocity)
	actor.move_and_slide()

	if "firing" in actor and not actor.firing:
		actor.update_facing()

	if not is_jetting and actor.is_on_floor():
		machine.transit("Idle")

	if not is_jetting and actor.velocity.y > 0:
		machine.transit("Fall")
