extends State

## enter ###########################################################

func enter(_opts = {}):
	pass

## exit ###########################################################

func exit():
	pass


## input ###########################################################

func unhandled_input(event):
	if actor.is_player:
		if Trolley.is_jump(event):
			machine.transit("Jump")
			return


## process ###########################################################

func process(_delta):
	pass


## physics ###########################################################

func physics_process(_delta):
	if abs(actor.move_vector.length()) > 0:
		machine.transit("Run")
		return

	actor.update_idle_anim()

	# slow down
	actor.velocity = lerp(actor.velocity, Vector2.ZERO, 0.5)

	actor.move_and_slide()
