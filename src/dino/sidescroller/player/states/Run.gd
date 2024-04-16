extends State

## properties ###########################################################

func face_movement_direction():
	return true

## enter ###########################################################

func enter(_opts = {}):
	actor.anim.play("run")

## physics ###########################################################

func physics_process(delta):
	if Input.is_action_just_pressed("jump") and actor.is_on_floor():
		machine.transit("Jump")
		return

	# gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	# apply move dir or slow down
	if actor.move_vector:
		var new_speed = actor.run_speed * actor.move_vector.x * delta
		actor.velocity.x = lerp(actor.velocity.x, new_speed, 0.5)
	else:
		actor.velocity.x = lerp(actor.velocity.x, 0.0, 0.5)

	var collided = actor.move_and_slide()
	if collided:
		var should_exit = actor.collision_check()
		if should_exit:
			return

	if actor.velocity.y > 0:
		machine.transit("Fall", {"coyote_time": true})
		return

	if abs(actor.velocity.x) < 1:
		machine.transit("Idle")
