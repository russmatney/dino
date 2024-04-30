extends State

## enter ###########################################################

func enter(_opts = {}):
	pass


## exit ###########################################################

func exit():
	pass


## process ###########################################################

func process(_delta):
	pass


## physics ###########################################################

func physics_process(delta):
	actor.update_run_anim()
	# apply move dir or slow down
	if actor.move_vector:
		var new_speed = actor.run_speed * actor.move_vector * delta
		actor.velocity = lerp(actor.velocity, Vector2.ONE*new_speed, 0.5)
	else:
		actor.velocity = lerp(actor.velocity, Vector2.ZERO, 0.5)

	actor.move_and_slide()
	# var should_return = actor.collision_check()
	# if should_return:
	# 	return

	if abs(actor.velocity.length()) < 1:
		machine.transit("Idle")
		return
