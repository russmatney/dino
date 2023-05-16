extends State

var fall_shake_thresholds = [
	{"threshold": 400, "shake": 0.3, "damage": 0, "sound": DJZ.S.fall},
	{"threshold": 550, "shake": 0.6, "damage": 1, "sound": DJZ.S.heavy_fall},
	{"threshold": 1000, "shake": 1.0, "damage": 2, "sound": DJZ.S.heavy_fall},
	]

var coyote_time = 0.4
var coyote_ttl

## enter ###########################################################

func enter(opts = {}):
	actor.anim.play("fall")

	if opts.get("coyote_time"):
		coyote_ttl = coyote_time


## exit ###########################################################

func exit():
	coyote_ttl = null


## physics ###########################################################

func physics_process(delta):
	if coyote_ttl != null:
		coyote_ttl -= delta
		if coyote_ttl > 0:
			if actor.is_player and Input.is_action_just_pressed("jump"):
				Debug.pr("Coyote jump!")
				machine.transit("Jump")
				return
		else:
			coyote_ttl = null

	# apply gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	# apply left/right movement
	if actor.move_vector:
		var new_speed = actor.air_speed * actor.move_vector.x * delta
		actor.velocity.x = lerp(actor.velocity.x, new_speed, 0.5)
	else:
		actor.velocity.x = lerp(actor.velocity.x, 0.0, 0.5)

	var vel_before_coll = actor.velocity
	actor.move_and_slide()

	# return to idle
	if actor.is_on_floor():
		var fall_speed = vel_before_coll.y

		var filtered = fall_shake_thresholds.filter(func(thresh): return fall_speed >= thresh["threshold"])
		filtered.sort_custom(func(a, b): return a["threshold"] >= b["threshold"])

		if filtered.size() > 0:
			var thresh = filtered[0]
			var shake = thresh["shake"]
			# var damage = thresh["damage"]
			Cam.screenshake(shake)
			DJZ.play(thresh["sound"])

		# TODO apply damage
		machine.transit("Idle")
		return
