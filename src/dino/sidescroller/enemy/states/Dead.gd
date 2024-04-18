extends State

## properties ###################################

func can_bump():
	return false

func can_attack():
	return false

## enter ###################################

func enter(ctx={}):
	actor.anim.play("dead")
	# maybe 'no_emit' is a better flag
	if not ctx.get("ignore_side_effects", false):
		actor.die()

## process ###################################

func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.speed)

	actor.move_and_slide()
