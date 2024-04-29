extends State

## properties #####################################################

func should_ignore_hit():
	return true

func can_bump():
	return false

## enter #####################################################

func enter(ctx={}):
	actor.anim.play("dead")
	actor.is_dead = true
	if not ctx.get("ignore_side_effects", false):
		Cam.hitstop("boss_dead", 0.2, 1.0, 0.8)
		DJZ.play(DJZ.S.soldierdead)
		actor.died.emit(actor)

## process #####################################################

func physics_process(delta):
	actor.velocity.y += actor.gravity * delta
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.speed)
	actor.move_and_slide()
