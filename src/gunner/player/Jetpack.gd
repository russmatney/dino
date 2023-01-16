extends State

var is_jetting

var jet_boost_ramp
var jet_boost_levels = [
	[1, 1.0],
	[0.5, 0.6],
	[0.2, 0.3],
	# initial speed from ground and in air
	[null, 4.0, 2.5],
	]

func jet_boost_factor(delta):
	jet_boost_ramp += delta
	for jbl in jet_boost_levels:
		if jbl[0] == null or jet_boost_ramp > jbl[0]:
			if jbl.size() == 3:
				if not actor.is_on_floor():
					return jbl[2]
			return jbl[1]

var jet_sound_every = 1.1
var jet_sound_in

func enter(_ctx={}):
	actor.anim.animation = "jetpack"
	is_jetting = true
	jet_boost_ramp = 0
	Gunner.play_sound("jet_boost")
	Cam.screenshake(0.2)

	jet_sound_in = jet_sound_every


func physics_process(delta):
	jet_sound_in -= delta
	if jet_sound_in <= 0:
		Gunner.play_sound("jet_boost")
		jet_sound_in = jet_sound_every
		Cam.screenshake(0.2)

	# TODO get_action_strength for shoulder buttons
	if Input.is_action_pressed("jetpack"):
		if not is_jetting:
			Gunner.interrupt_sound("jet_echo")
			Gunner.play_sound("jet_boost")
			is_jetting = true
			jet_sound_in = jet_sound_every
	else:
		Gunner.interrupt_sound("jet_boost")
		if is_jetting:
			Gunner.play_sound("jet_echo")
		jet_boost_ramp = 0
		is_jetting = false

	if is_jetting:
		var boost_factor = jet_boost_factor(delta)

		actor.jet_anim.set_visible(true)
		if boost_factor > 0.5:
			actor.jet_anim.animation = "all"
		else:
			actor.jet_anim.animation = "init"
		# print("boost factor: ", boost_factor)
		# print("jet boost ramp: ", jet_boost_ramp)
		actor.velocity.y -= actor.jetpack_boost * boost_factor * delta
		actor.velocity.y += actor.gravity * delta / 4
	else:
		actor.jet_anim.set_visible(false)
		actor.velocity.y += actor.gravity * delta

	if actor.move_dir:
		actor.velocity.x = actor.air_speed * actor.move_dir.x
		# TODO clamp fall speed
	else:
		actor.velocity.x = actor.velocity.x * 0.9 * delta

	actor.velocity = actor.move_and_slide(actor.velocity, Vector2.UP)

	if not actor.firing:
		actor.update_facing()

	if not is_jetting and actor.is_on_floor():
		machine.transit("Idle")

	if not is_jetting and actor.velocity.y > 0:
		# TODO fall some distance first?
		machine.transit("Fall")
