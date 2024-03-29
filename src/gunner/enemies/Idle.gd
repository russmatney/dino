extends State

var walk_after = 3
var tt_walk


func enter(_ctx = {}):
	actor.velocity = Vector2.ZERO
	actor.anim.animation = "idle"
	tt_walk = walk_after


func process(delta):
	tt_walk -= delta
	if tt_walk <= 0:
		machine.transit("Walk")


func physics_process(delta):
	actor.velocity.y += actor.gravity * delta
	actor.set_velocity(actor.velocity)
	actor.set_up_direction(Vector2.UP)
	actor.move_and_slide()
	actor.velocity = actor.velocity
