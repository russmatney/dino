extends State

## enter ###########################################################


func enter(_opts = {}):
	actor.anim.play("walk")


## physics ###########################################################

func physics_process(delta):
	if actor.move_vector.abs().length() < 0.1:
		transit("Idle")
		return

	var new_vel = actor.move_vector * actor.walk_speed * delta
	actor.velocity = actor.velocity.lerp(new_vel, 0.7)
	actor.move_and_slide()
