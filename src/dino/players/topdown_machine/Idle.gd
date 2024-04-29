extends State

## enter ###########################################################

func enter(_opts = {}):
	# clear movement input (so transting to idle doesn't get stuck in an idle/run loop)
	actor.move_vector = Vector2.ZERO

## exit ###########################################################

func exit():
	pass


## input ###########################################################

func unhandled_input(event):
	if Trolls.is_jump(event):
		machine.transit("Jump")
		return

## physics ###########################################################

func physics_process(_delta):
	actor.update_idle_anim()

	if actor.move_vector.abs().length() > 0:
		machine.transit("Run")
		return

	# slow down
	actor.velocity = lerp(actor.velocity, Vector2.ZERO, 0.5)

	actor.move_and_slide()
