extends State

func enter(ctx={}):
	actor.anim.play("dead")
	actor.skull_particles.set_emitting(true)
	if not ctx.get("ignore_side_effects", false):
		Cam.screenshake(0.3)
		# DJZ.play(DJZ.playerdead)
		actor.player_death.emit()


func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)

	actor.move_and_slide()
