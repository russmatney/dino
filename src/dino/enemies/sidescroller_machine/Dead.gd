extends State

## properties ###################################

func can_bump():
	return false

func can_attack():
	return false

func can_hop():
	return false

## enter ###################################

func enter(ctx={}):
	actor.anim.play("dead")
	# maybe 'no_emit' is a better flag
	if not ctx.get("ignore_side_effects", false):
		actor.die()

## process ###################################

func physics_process(delta):
	if actor.should_crawl_on_walls:
		# wall-crawlers shouldn't fall in idle (stay on the wall)
		pass
	else:
		actor.velocity.y += actor.gravity * delta

	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.speed)

	actor.move_and_slide()
