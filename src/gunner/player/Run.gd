# Run
extends State

func enter(_ctx = {}):
	actor.anim.animation = "run"
	print("entering run")

func physics_process(delta):
	if actor.move_dir:
		actor.velocity.x = actor.speed * actor.move_dir.x
		actor.velocity.y += actor.gravity * delta

		# TODO clamp run speed

		actor.velocity = actor.move_and_slide(actor.velocity,
			Vector2.UP)

		# skip if we're strafing (strafing should be another state)
		actor.update_facing()
	elif abs(actor.velocity.y) > 0:
		machine.transit("Fall")
	else:
		machine.transit("Idle")
