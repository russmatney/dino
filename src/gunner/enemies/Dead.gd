extends State

func enter(_msg = {}):
	actor.anim.animation = "dead"
	actor.dead = true
	actor.die()


func physics_process(delta):
	actor.velocity.y += actor.gravity * delta
	actor.velocity = actor.move_and_slide(actor.velocity, Vector2.UP)
