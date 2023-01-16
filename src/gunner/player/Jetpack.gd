extends State

var is_jetting
var jet_boost_ramp

var jet_level_one = 0.3
var jet_level_two = 1
var jet_level_three = 2

func jet_boost_factor(delta):
	jet_boost_ramp += delta
	if jet_boost_ramp > jet_level_three:
		return 1
	elif jet_boost_ramp > jet_level_two:
		return 0.6
	elif jet_boost_ramp > jet_level_one:
		return 0.3
	else:
		return 0.1

func enter(_ctx={}):
	print("enter jetpack")
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
		# print("boost factor: ", boost_factor)
		# print("jet boost ramp: ", jet_boost_ramp)
		actor.velocity.y -= actor.jetpack_boost * boost_factor * delta
		actor.velocity.y += actor.gravity * delta / 4
	else:
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
