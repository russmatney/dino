extends State

func enter(_msg = {}):
	actor.velocity = Vector2.ZERO
	actor.anim.animation = "dead"

	# actor.collision_shape.set_disabled(true)
	actor.die()


func physics_process(delta):
	if actor and is_instance_valid(actor):
		actor.velocity.y += actor.gravity * delta
		actor.velocity = actor.move_and_slide(actor.velocity, Vector2.UP)
