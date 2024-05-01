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
		Juice.hitstop({name="boss_dead", time_scale=0.2, duration=1.0, trauma=0.8})
		Sounds.play(Sounds.S.soldierdead)
		actor.died.emit(actor)

## process #####################################################

func physics_process(delta):
	actor.velocity.y += actor.gravity * delta
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.speed)
	actor.move_and_slide()
