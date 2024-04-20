extends State

## properties ###################################

func can_bump():
	return true

func can_attack():
	return true

func can_hop():
	return true

## enter ###################################

func enter(ctx={}):
	var dir = ctx.get("dir", actor.facing_vector)
	actor.move_vector = dir
	actor.anim.play("run")

## process ###################################

func physics_process(delta):
	if actor.can_see_player:
		machine.transit("Fire")
		return

	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	if actor.move_vector.x > 0:
		actor.face_right()
	elif actor.move_vector.x < 0:
		actor.face_left()

	# consider a new state for when we can see the player
	if actor.front_ray:
		if not actor.front_ray.is_colliding():
			if len(actor.line_of_sights) > 0:
				for lo in actor.line_of_sights:
					if lo.is_colliding():
						machine.transit("Idle", {stop=true})
						return
			actor.turn()

	if actor.crawl_on_side == null:
		if actor.is_on_wall():
			if len(actor.line_of_sights) > 0:
				for lo in actor.line_of_sights:
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
	if actor.move_vector.length() > 0:
		if actor.crawl_on_side:
			match(actor.crawl_on_side):
				Vector2.DOWN:
					actor.velocity.x = actor.move_vector.x * actor.speed
				Vector2.UP:
					actor.velocity.x = -1 * actor.move_vector.x * actor.speed
				Vector2.LEFT:
					actor.velocity.y = -1 * actor.move_vector.x * actor.speed
				Vector2.RIGHT:
					actor.velocity.y = actor.move_vector.x * actor.speed
		else:
			actor.velocity.x = actor.move_vector.x * actor.speed

	actor.move_and_slide()
