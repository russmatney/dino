extends State

var is_jetting
var jet_boost_ramp

var jet_boost_levels = [
	[1, 1.0],
	[0.5, 0.6],
	[0.2, 0.3],
	[null, 4.0],
	]

func jet_boost_factor(delta):
	jet_boost_ramp += delta
	for jbl in jet_boost_levels:
		if jbl[0] == null or jet_boost_ramp > jbl[0]:
			return jbl[1]

func enter(_ctx={}):
	actor.anim.animation = "jetpack"
	is_jetting = true
	jet_boost_ramp = 0


func physics_process(delta):
	# TODO get_action_strength for shoulder buttons
	if Input.is_action_pressed("jetpack"):
		is_jetting = true
	else:
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
