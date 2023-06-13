extends State

## enter ###########################################################

func enter(_opts = {}):
	if actor.facing_vector.y > 0:
		actor.anim.play("run_down")
	elif actor.facing_vector.y < 0:
		actor.anim.play("run_up")
	elif actor.facing_vector.x > 0:
		actor.anim.play("run_right")
	elif actor.facing_vector.x < 0:
		# presuming anim h_flip is done elsewhere?
		actor.anim.play("run_right")
	else:
		actor.anim.play("run_down")


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

func physics_process(delta):
	# apply move dir or slow down
	if actor.move_vector:
		var new_speed = actor.run_speed * actor.move_vector * delta
		actor.velocity = lerp(actor.velocity, Vector2.ONE*new_speed, 0.5)
	else:
		actor.velocity = lerp(actor.velocity, Vector2.ZERO, 0.5)

	actor.move_and_slide()

	if abs(actor.velocity.length()) < 1:
		machine.transit("Idle")
