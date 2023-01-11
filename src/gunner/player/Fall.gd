# Fall
extends State

func enter(_ctx = {}):
	# actor.anim.animation = "fall"
	actor.anim.animation = "run"
	print("entering fall")

func physics_process(delta):
	actor.velocity.y += actor.gravity * delta

	if actor.move_dir:
		actor.velocity.x = actor.air_speed * actor.move_dir.x
		# TODO clamp fall speed
	else:
		# slow down
		actor.velocity.x = actor.velocity.x * 0.9 * delta

	actor.velocity = actor.move_and_slide(actor.velocity, Vector2.UP)
	actor.update_facing()


	if actor.is_on_floor():
		machine.transit("Idle")
