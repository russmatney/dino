extends State


func enter(_msg = {}):
	owner.velocity = Vector2.ZERO
	owner.anim.animation = "dead"
	owner.dead = true
	owner.die()


func physics_process(delta):
	owner.velocity.y += owner.gravity * delta
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
