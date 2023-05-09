extends State

## enter ###########################################################


func enter(opts = {}):
	Hood.notif("Walk!", opts)


## physics ###########################################################

var walk_speed = 10000

func physics_process(delta):
	if actor.move_vector.abs().length() < 0.1:
		transit("Idle")
		return

	var new_vel = actor.move_vector * walk_speed * delta
	actor.velocity = actor.velocity.lerp(new_vel, 0.7)
	actor.move_and_slide()
