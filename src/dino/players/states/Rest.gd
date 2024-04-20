extends State

var exit_cb

## properties ###########################################################

func can_bump():
	return false

func can_act():
	return false

## enter ###########################################################

func enter(opts = {}):
	exit_cb = opts.get("exit_cb")

	actor.anim.play("rest")

	var heal_t = create_tween()
	heal_t.set_loops(3)
	heal_t.tween_callback(func():
		actor.recover_health(1)
		DJZ.play(DJZ.S.playerheal)
		if actor.heart_particles != null:
			# force one-shot emission
			actor.heart_particles.set_emitting(true)
			actor.heart_particles.restart()
		).set_delay(1)
	heal_t.finished.connect(transit.bind("Idle"))

## exit ###########################################################

func exit():
	# supports candle.put_out, room cam point reactivation
	if exit_cb != null:
		exit_cb.call()


## physics ###########################################################

func physics_process(_delta):
	actor.move_and_slide()
