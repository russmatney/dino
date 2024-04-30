extends State

var chasing

## enter ###########################################################

func enter(opts = {}):
	chasing = opts.get("chasing")


## exit ###########################################################

func exit():
	pass


## physics ###########################################################

func physics_process(delta):
	if not chasing:
		transit("Idle")
		return

	if chasing and not is_instance_valid(chasing):
		transit("Idle")
		return

	if not chasing in actor.notice_box_bodies:
		transit("Idle")
		return

	var diff = chasing.global_position - actor.global_position
	actor.move_vector = diff.normalized()
	actor.update_facing()
	actor.update_run_anim()

	var new_vel = actor.move_vector * actor.run_speed * delta
	actor.velocity = actor.velocity.lerp(new_vel, 0.7)
	actor.move_and_slide()
