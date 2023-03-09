extends State

func enter(ctx={}):
	actor.anim.play("dead")
	actor.dead = true
	if not ctx.get("ignore_side_effects", false):
		Cam.hitstop("monstroar_dead", 0.2, 1.0, 0.8)
		# TODO monstroar sound
		MvaniaSounds.play_sound("soldierdead")

		actor.died.emit(actor)


func physics_process(delta):
	actor.velocity.y += actor.GRAVITY * delta
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)
	actor.move_and_slide()
