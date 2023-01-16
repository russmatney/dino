# Run
extends State


func enter(_ctx = {}):
	actor.anim.animation = "run"
	# perhaps unnecessary jump reset
	actor.jump_count = 0


func physics_process(delta):
	if actor.velocity.y > 0:
		machine.transit("Fall")
	elif actor.move_dir:
		actor.velocity.x = actor.speed * actor.move_dir.x
		actor.velocity.y += actor.gravity * delta

		# TODO clamp run speed

		actor.velocity = actor.move_and_slide(actor.velocity, Vector2.UP)

		if not actor.firing:
			actor.update_facing()
	else:
		machine.transit("Idle")
