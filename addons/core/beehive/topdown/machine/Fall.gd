extends State


var fall_time = 0.6
var fall_ttl
var fall_scale_factor = 0.2

## enter ###########################################################

func enter(opts = {}):
	actor.anim.play("fall")
	DJZ.play(DJZ.S.fall)
	fall_ttl = U.get_(opts, "fall_time", fall_time)
	actor.velocity = Vector2.ZERO

	var tween = create_tween()
	tween.tween_property(actor, "scale", Vector2.ONE*fall_scale_factor, fall_ttl)
	tween.tween_property(actor, "modulate:a", 0.0, fall_ttl)

	actor.stamp()

	if actor.skull_particles != null:
		# force one-shot emission
		actor.skull_particles.set_emitting(true)
		actor.skull_particles.restart()



## exit ###########################################################

func exit():
	pass


## input ###########################################################

func unhandled_input(_event):
	pass


## physics ###########################################################

func physics_process(delta):
	fall_ttl -= delta

	if fall_ttl <= 0:
		# reset handler? move back to safe position? die? fire signal?
		return

	actor.move_and_slide()
