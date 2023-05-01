extends State


func enter(ctx = {}):
	actor.velocity = Vector2.ZERO
	actor.anim.animation = "dead"
	actor.die()

	if "shake" in ctx and ctx["shake"]:
		DJZ.play(DJZ.heavy_landing)
		if typeof(ctx["shake"]) == TYPE_FLOAT:
			Cam.screenshake(ctx["shake"])
		else:
			Cam.screenshake(0.5)


func physics_process(delta):
	if actor and is_instance_valid(actor):
		actor.velocity.y += actor.gravity * delta
		actor.set_velocity(actor.velocity)
		actor.move_and_slide()
