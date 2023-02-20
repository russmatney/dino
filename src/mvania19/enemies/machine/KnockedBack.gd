extends State


func enter(ctx={}):
	var dir = ctx.get("direction", Vector2.LEFT)
	var kb_vel
	if actor.health <= 0:
		actor.anim.play("dying")
		kb_vel = actor.DYING_VELOCITY
	else:
		actor.anim.play("knockback")
		kb_vel = actor.KNOCKBACK_VELOCITY

	# look into the punch
	if dir == Vector2.LEFT:
		actor.face_right()
	elif dir == Vector2.RIGHT:
		actor.face_left()

	actor.velocity += Vector2(0, kb_vel) + dir * actor.KNOCKBACK_VELOCITY_HORIZONTAL


func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	actor.move_and_slide()

	if actor.is_on_floor():
		if actor.health <= 0:
			transit("Dead")
		else:
			# TODO transit back to previous state?
			transit("Idle")
