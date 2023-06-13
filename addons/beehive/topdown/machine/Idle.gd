extends State

## enter ###########################################################

func enter(_opts = {}):
	if actor.facing_vector.y > 0:
		actor.anim.play("idle_down")
	elif actor.facing_vector.y < 0:
		actor.anim.play("idle_up")
	elif actor.facing_vector.x > 0:
		actor.anim.play("idle_right")
	elif actor.facing_vector.x < 0:
		# presuming anim h_flip is done elsewhere?
		actor.anim.play("idle_right")
	else:
		actor.anim.play("idle_down")

## exit ###########################################################

func exit():
	pass


## input ###########################################################

func unhandled_input(_event):
	pass


## process ###########################################################

func process(_delta):
	pass


## physics ###########################################################

func physics_process(_delta):
	if abs(actor.move_vector.length()) > 0:
		machine.transit("Run")
		return

	# slow down
	actor.velocity = lerp(actor.velocity, Vector2.ZERO, 0.5)

	actor.move_and_slide()
