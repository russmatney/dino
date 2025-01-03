extends State

# var kick_time = 0.5
# var kick_ttl

## enter ###########################################################

func enter(_opts = {}):
	# kick_ttl = kick_time
	kicked_bodies = []

	actor.anim.animation_finished.connect(on_animation_finished)
	actor.anim.frame_changed.connect(on_frame_changed)

	actor.anim.play("kick")


## exit ###########################################################

func exit():
	# kick_ttl = null
	kicked_bodies = []
	actor.anim.animation_finished.disconnect(on_animation_finished)
	actor.anim.frame_changed.disconnect(on_frame_changed)


## kick ###########################################################

var kicked_bodies = []

func kick():
	for body in actor.punch_box_bodies:
		if is_instance_valid(body) and not body in kicked_bodies:
			if "is_dead" in body and not body.is_dead and "machine" in body:
				body.machine.transit("Kicked", {kicked_by=actor, direction=actor.facing_vector})
				Juice.hitstop({name="kick", time_scale=0.05, duration=0.1, trauma=0.3})
				kicked_bodies.append(body)
			elif body.is_in_group("destructibles"):
				body.take_hit({hit_type="kick", body=actor})
				kicked_bodies.append(body)

func on_animation_finished():
	if actor.anim.animation == "kick":
		finish_kick()

func on_frame_changed():
	if actor.anim.animation == "kick":
		if not actor.anim.frame in actor.passive_frames(actor.anim):
			kick()

func finish_kick():
	transit("Idle")

## physics ###########################################################

func physics_process(_delta):
	# if kick_ttl == null:
	# 	return

	# kick_ttl -= delta

	# if kick_ttl <= 0:
	# 	transit("Idle")
	# 	return

	actor.velocity = Vector2.ZERO
	actor.move_and_slide()
