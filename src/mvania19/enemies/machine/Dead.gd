extends State


func enter(ctx={}):
	actor.anim.play(actor.death_animation)
	# maybe 'no_emit' is a better flag
	if not ctx.get("ignore_side_effects", false):
		actor.died.emit(actor)


func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)

	actor.move_and_slide()
