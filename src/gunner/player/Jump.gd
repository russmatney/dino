# Jump
extends State

var has_jumped

func enter(_ctx = {}):
	# actor.anim.animation = "jump"
	actor.anim.animation = "idle"

	actor.velocity.y -= actor.jump_impulse
	has_jumped = false

	actor.can_wall_jump = false

func physics_process(delta):
	actor.velocity.y += actor.gravity * delta

	if has_jumped:
		if actor.move_dir:
			actor.velocity.x = actor.air_speed * actor.move_dir.x
			# TODO clamp jump speed
		else:
			# slow down
			actor.velocity.x = actor.velocity.x * 0.99 * delta

	actor.velocity = actor.move_and_slide(actor.velocity, Vector2.UP)
	actor.update_facing()

	if has_jumped:
		# if actor.velocity.y >= 1.0:
		# 	machine.transit("Air")
		if actor.is_on_floor():
			machine.transit("Idle")

	if not actor.is_on_floor():
		has_jumped = true

	if actor.is_on_wall():
		actor.can_wall_jump = true
