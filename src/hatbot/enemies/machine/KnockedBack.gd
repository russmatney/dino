extends State


func enter(ctx={}):
	actor.knocked_back.emit(actor)

	DJSounds.play_sound(DJSounds.enemyhurt)

	var dir = ctx.get("direction", Vector2.LEFT)
	var dying = ctx.get("dying", false)
	var kb_vel = actor.DYING_VELOCITY if dying else actor.KNOCKBACK_VELOCITY

	if not "crawl_on_side" in actor:
		# look into the punch
		if dir == Vector2.LEFT:
			actor.face_right()
		elif dir == Vector2.RIGHT:
			actor.face_left()

	actor.velocity += Vector2(0, kb_vel) + dir * actor.KNOCKBACK_VELOCITY_HORIZONTAL


func physics_process(delta):
	actor.velocity.y += actor.GRAVITY * delta
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)
	actor.move_and_slide()

	# TODO wait for dying animation to end
	if actor.is_on_floor() or "crawl_on_side" in actor:
		if actor.health <= 0:
			transit("Dead")
		else:
			# TODO transit back to previous state?
			transit("Idle")