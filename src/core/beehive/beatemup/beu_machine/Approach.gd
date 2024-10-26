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
		# walk closer, rather than stopping on the edge
		transit("Attack", {attacking=approaching})
		return

	var diff = approaching.global_position - actor.global_position
	var new_vel = diff.normalized() * actor.walk_speed * delta
	actor.velocity = actor.velocity.lerp(new_vel, 0.7)
	actor.move_and_slide()

	actor.face_body(approaching)
