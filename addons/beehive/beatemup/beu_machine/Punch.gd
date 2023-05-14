extends State

# var punch_time = 0.4
# var punch_ttl

var initial_punch_count = 0
var punch_count
var punched_again_pressed

var next_state

## enter ###########################################################

func enter(opts = {}):
	punch_count = Util.get_(opts, "punch_count", initial_punch_count)

	actor.anim.animation_finished.connect(on_animation_finished)
	actor.anim.frame_changed.connect(on_frame_changed)

	punched_again_pressed = false
	# punch_ttl = punch_time
	punched_bodies = []

	if punch_count == 0:
		actor.anim.play("punch")
	else:
		actor.anim.play("punch_2")

	next_state = opts.get("next_state")


## exit ###########################################################

func exit():
	# punch_ttl = null
	next_state = null
	punched_bodies = []

	actor.anim.animation_finished.disconnect(on_animation_finished)
	actor.anim.frame_changed.disconnect(on_frame_changed)


## punch ###########################################################

var punched_bodies = []

func punch():
	for body in actor.punch_box_bodies:
		if is_instance_valid(body) and not body in punched_bodies and not body.is_dead and "machine" in body:
			body.machine.transit("Punched", {punched_by=actor})
			punched_bodies.append(body)
			Cam.hitstop("punch", 0.1, 0.1, 0.2)
			# Cam.screenshake(0.3)

func on_animation_finished():
	if actor.anim.animation == "punch" or actor.anim.animation == "punch_2":
		finish_punch()

func on_frame_changed():
	if actor.anim.animation == "punch" or actor.anim.animation == "punch_2":
		if not actor.anim.frame in actor.passive_frames(actor.anim):
			punch()

func finish_punch():
	var hit_anything = len(punched_bodies) > 0
	# AI combo support
	if next_state != null:
		transit(next_state, {
			hit_anything=hit_anything,
			punch_count=punch_count + 1,
			})

	# player combo support
	elif hit_anything and punched_again_pressed and punch_count == 0:
		transit("Punch", {punch_count=1})
	elif hit_anything and punched_again_pressed and punch_count == 1:
		transit("Kick")
	else:
		transit("Idle")


## unhandled_input ###########################################################

func unhandled_input(event):
	if Trolley.is_attack(event) and not punched_again_pressed:
		punched_again_pressed = true
		return


## physics ###########################################################

func physics_process(_delta):
	# if punch_ttl == null:
	# 	return

	# punch_ttl -= delta

	# if punch_ttl <= 0:
	# 	finish_punch()
	# 	return

	actor.velocity = Vector2.ZERO
	actor.move_and_slide()
