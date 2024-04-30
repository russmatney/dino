extends State

var wander_in = [0.8, 2.2, 1.5]
var wander_in_t

var hop_in = [1.4, 2.8, 0.7]
var hop_in_t

var home_position

## enter ###########################################################

func enter(opts = {}):
	# clear movement input (so transting to idle doesn't get stuck in an idle/run loop)
	actor.move_vector = Vector2.ZERO

	home_position = opts.get("home_position", home_position)
	home_position = U._or(home_position, actor.global_position)

	if actor.should_wander:
		wander_in_t = U.rand_of(wander_in)

	if actor.should_hop:
		hop_in_t = U.rand_of(hop_in)

## physics ###########################################################

func physics_process(delta):
	actor.update_idle_anim()

	if actor.move_vector.abs().length() > 0:
		machine.transit("Run")
		return

	if actor.should_notice:
		if len(actor.notice_box_bodies) > 0:
			transit("Notice", {noticing=actor.notice_box_bodies[0]})
			return

	if actor.should_wander:
		wander_in_t -= delta
		if wander_in_t <= 0:
			transit("Wander")
			return

	if actor.should_hop:
		hop_in_t -= delta
		if hop_in_t <= 0:
			transit("Hop")
			return

	# slow down
	actor.velocity = lerp(actor.velocity, Vector2.ZERO, 0.5)

	actor.move_and_slide()
