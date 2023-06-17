extends State

var approaching

## enter ###########################################################

func enter(opts = {}):
	actor.anim.play("walk")
	# reuse approaching if it hasn't been cleared
	approaching = opts.get("approaching", approaching)
	if approaching and is_instance_valid(approaching):
		approaching.add_attacker(actor)

func exit():
	pass

## physics ###########################################################

func physics_process(delta):
	if approaching and not is_instance_valid(approaching):
		approaching = null
		transit("Idle")
		return

	if approaching in actor.punch_box_bodies:
		# TODO consider walking another view pixels closer, rather than stopping right on the edge
		transit("Attack", {attacking=approaching})
		return

	var diff = approaching.global_position - actor.global_position
	# maybe relevant?
	# actor.move_vector = diff.normalized()

	# TODO move to some position on left/right of actor
	# maybe easier to align feet/shadow

	var new_vel = diff.normalized() * actor.walk_speed * delta
	actor.velocity = actor.velocity.lerp(new_vel, 0.7)
	actor.move_and_slide()

	actor.face_body(approaching)
