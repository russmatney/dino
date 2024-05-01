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
	actor.knocked_back.emit(actor)

	Sounds.play(Sounds.S.enemyhurt)

	var dir = U.get_(ctx, "direction", Vector2.LEFT)
	var dying = ctx.get("dying", false)
	var kb_vel = actor.dying_velocity if dying else actor.knockback_velocity
	if kb_vel == null:
		kb_vel = 5

	if not "crawl_on_side" in actor:
		# look into the punch
		if dir == Vector2.LEFT:
			actor.face_right()
		elif dir == Vector2.RIGHT:
			actor.face_left()

	actor.velocity += Vector2(0, kb_vel) + dir * actor.knockback_velocity_horizontal

## process ###################################

func physics_process(delta):
	actor.velocity.y += actor.gravity * delta
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.speed)
	actor.move_and_slide()

	if actor.is_on_floor() or "crawl_on_side" in actor:
		# once we hit the floor, assess the damage
		if actor.health <= 0:
			transit("Dead")
		else:
			transit("Idle")
