# Idle
extends State


func enter(ctx = {}):
	actor.anim.animation = "idle"
	actor.jump_count = 0

	if "shake" in ctx and ctx["shake"]:
		DJZ.play(DJZ.S.heavy_landing)
		if typeof(ctx["shake"]) == TYPE_FLOAT:
			Cam.screenshake(ctx["shake"])
		else:
			Cam.screenshake(0.25)


func physics_process(delta):
	if actor.move_dir:
		if actor.is_on_floor() and abs(actor.move_dir.x) > 0:
			machine.transit("Run")
	else:
		# slow down
		actor.velocity.x = actor.velocity.x * 0.9 * delta

	actor.velocity.y += actor.gravity * delta
	# TODO clamp fall speed?
	actor.set_velocity(actor.velocity)
	actor.move_and_slide()

	# if not actor.is_on_floor() and actor.velocity.y > 0:
	# 	machine.transit("Fall")
