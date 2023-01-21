extends State

func enter(ctx = {}):
	actor.velocity = Vector2.ZERO
	actor.anim.animation = "dead"
	actor.die()

	if "shake" in ctx and ctx["shake"]:
		GunnerSounds.play_sound("heavy_landing")
		if typeof(ctx["shake"]) == TYPE_REAL:
			Cam.screenshake(ctx["shake"])
		else:
			Cam.screenshake(0.5)


func physics_process(delta):
	if actor and is_instance_valid(actor):
		actor.velocity.y += actor.gravity * delta
		actor.velocity = actor.move_and_slide(actor.velocity, Vector2.UP)
