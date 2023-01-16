# Idle
extends State


func enter(ctx = {}):
	actor.anim.animation = "idle"
	actor.jump_count = 0

	if "shake" in ctx and ctx["shake"]:
		Gunner.play_sound("heavy_landing")
		if typeof(ctx["shake"]) == TYPE_REAL:
			Cam.screenshake(ctx["shake"])
		else:
			Cam.screenshake(0.25)

	# Gunner.play_sound("step")


func physics_process(delta):
	if actor.move_dir:
		if actor.is_on_floor() and abs(actor.move_dir.x) > 0:
			machine.transit("Run")
	else:
		# slow down
		actor.velocity.x = actor.velocity.x * 0.9 * delta

	actor.velocity.y += actor.gravity * delta
	# TODO clamp fall speed?
	actor.velocity = actor.move_and_slide(actor.velocity, Vector2.UP)

	# if not actor.is_on_floor() and actor.velocity.y > 0:
	# 	machine.transit("Fall")
