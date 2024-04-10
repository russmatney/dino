extends State


func enter(_msg = {}):
	actor.velocity = Vector2.ZERO
	actor.anim.animation = "dead"
	actor.die()


func physics_process(delta):
	if actor and is_instance_valid(actor):
		actor.velocity.y += actor.gravity * delta
		actor.set_velocity(actor.velocity)
		actor.set_up_direction(Vector2.UP)
		actor.move_and_slide()
		actor.velocity = actor.velocity
