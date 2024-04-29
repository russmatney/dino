extends State

## properties ###################################

func can_bump():
	return false

func can_attack():
	return false

func can_hop():
	return false

func can_be_initial_state():
	return true

## vars ###################################

## enter #####################################################################

func enter(ctx={}):
	var dir = ctx.get("dir", actor.facing_vector)
	actor.move_vector = dir
	actor.anim.play("walk")


## process ###################################

func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	if actor.move_vector.x > 0:
		actor.face_right()
	elif actor.move_vector.x < 0:
		actor.face_left()

	if actor.front_ray:
		if not actor.front_ray.is_colliding():
			if len(actor.line_of_sights) > 0:
				for lo in actor.line_of_sights:
					if lo.is_colliding():
						machine.transit("Idle", {stop=true})
						return
			actor.turn()

	if actor.is_on_wall():
		if len(actor.line_of_sights) > 0:
			for lo in actor.line_of_sights:
				if lo.is_colliding():
					machine.transit("Idle", {stop=true})
					return
		actor.turn()

	# apply speed last to allow for turn first
	if actor.move_vector.length() > 0:
		actor.velocity.x = actor.move_vector.x * actor.speed

	actor.move_and_slide()
