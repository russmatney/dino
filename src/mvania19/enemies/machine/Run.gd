extends State


func enter(ctx={}):
	var dir = ctx.get("dir", actor.facing)
	actor.move_dir = dir
	actor.anim.play("run")


func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	if actor.move_dir.x > 0:
		actor.face_right()
	elif actor.move_dir.x < 0:
		actor.face_left()

	# TODO consider a new state for when we can see the player
	if not actor.front_ray.is_colliding():
		for lo in actor.line_of_sights:
			if lo.is_colliding():
				machine.transit("Idle", {stop=true})
				return
		actor.turn()

	if actor.is_on_wall():
		for lo in actor.line_of_sights:
			if lo.is_colliding():
				machine.transit("Idle", {stop=true})
				return
		actor.turn()

	# apply speed last to allow for turn first
	if actor.move_dir.length() > 0:
		actor.velocity.x = actor.move_dir.x * actor.SPEED

	actor.move_and_slide()
