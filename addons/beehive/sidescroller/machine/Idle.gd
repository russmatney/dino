extends State

## enter ###########################################################

func enter(_opts = {}):
	actor.anim.play("idle")


## exit ###########################################################

func exit():
	pass


## physics ###########################################################

func physics_process(delta):
	if actor.is_player and Input.is_action_just_pressed("jump") and actor.is_on_floor():
		machine.transit("Jump")
		return

	if actor.move_vector.x != 0:
		machine.transit("Run")
		return

	# slow down
	actor.velocity.x = lerp(actor.velocity.x, 0.0, 0.5)

	# gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	actor.move_and_slide()
