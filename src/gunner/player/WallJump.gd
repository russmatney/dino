# WallJump
extends State

func enter(_ctx = {}):
	# actor.anim.animation = "jump"
	actor.anim.animation = "run"
	actor.velocity.y = -1 * actor.jump_impulse

	actor.can_wall_jump = false

func physics_process(delta):
	actor.velocity.y += actor.gravity * delta

	if actor.move_dir:
		actor.velocity.x = actor.air_speed * actor.move_dir.x
		# TODO clamp jump speed
	else:
		# slow down
		actor.velocity.x = actor.velocity.x * 0.99 * delta

	actor.velocity = actor.move_and_slide(actor.velocity, Vector2.UP)
	actor.update_facing()

	if actor.is_on_floor():
		machine.transit("Idle")
