extends State


func enter(ctx={}):
	var dir = ctx.get("dir", actor.facing)
	actor.move_dir = dir
	actor.anim.play(actor.run_animation)


func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	if actor.move_dir.x > 0:
		actor.face_right()
	elif actor.move_dir.x < 0:
		actor.face_left()

	# TODO consider a new state for when we can see the player
	if "front_ray" in actor:
		if not actor.front_ray.is_colliding():
			for lo in actor.line_of_sights if "line_of_sights" in actor else []:
				if lo.is_colliding():
					machine.transit("Idle", {stop=true})
					return
			actor.turn()

	if not "crawl_on_side" in actor:
		if actor.is_on_wall():
			for lo in actor.line_of_sights if "line_of_sights" in actor else []:
				if lo.is_colliding():
					machine.transit("Idle", {stop=true})
					return
			actor.turn()
	else:
		match(actor.crawl_on_side):
			Vector2.DOWN:
				if actor.is_on_wall():
					actor.turn()
			Vector2.UP:
				if actor.is_on_wall():
					actor.turn()
			Vector2.LEFT:
				if actor.is_on_floor() or actor.is_on_ceiling():
					actor.turn()
			Vector2.RIGHT:
				if actor.is_on_floor() or actor.is_on_ceiling():
					actor.turn()

	# apply speed last to allow for turn first
	if actor.move_dir.length() > 0:
		if "crawl_on_side" in actor:
			match(actor.crawl_on_side):
				Vector2.DOWN:
					actor.velocity.x = actor.move_dir.x * actor.SPEED
				Vector2.UP:
					actor.velocity.x = -1 * actor.move_dir.x * actor.SPEED
				Vector2.LEFT:
					actor.velocity.y = -1 * actor.move_dir.x * actor.SPEED
				Vector2.RIGHT:
					actor.velocity.y = actor.move_dir.x * actor.SPEED
		else:
			actor.velocity.x = actor.move_dir.x * actor.SPEED

	actor.move_and_slide()
