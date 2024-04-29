extends State

var fall_shake_thresholds = [
	{"threshold": 750, "shake": 0.3, "damage": 0, "sound": DJZ.S.fall},
	{"threshold": 1100, "shake": 0.6, "damage": 1, "sound": DJZ.S.heavy_fall},
	{"threshold": 1500, "shake": 1.0, "damage": 2, "sound": DJZ.S.heavy_fall},
	]

var coyote_time = 0.4
var coyote_ttl

var double_jumping

## properties ###########################################################

func face_movement_direction():
	return true

## enter ###########################################################

func enter(opts = {}):
	double_jumping = opts.get("double_jumping")
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
			if Input.is_action_just_pressed("jump"):
				machine.transit("Jump")
				return
		else:
			coyote_ttl = null

	# double jump
	if not double_jumping and actor.has_double_jump \
		and Input.is_action_just_pressed("jump"):
		machine.transit("Jump", {"double_jumping": true})
		return

	# apply gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.fall_gravity * delta

	# apply left/right movement
	if actor.move_vector:
		var new_speed = actor.air_speed * actor.move_vector.x * delta
		actor.velocity.x = lerp(actor.velocity.x, new_speed, 0.5)
	else:
		actor.velocity.x = lerp(actor.velocity.x, 0.0, 0.5)

	if actor.should_start_climb():
		machine.transit("Climb")
		return

	var vel_before_coll = actor.velocity
	var collided = actor.move_and_slide()
	if collided:
		var should_exit = actor.collision_check()
		if should_exit:
			return

	# return to idle
	if actor.is_on_floor():
		var fall_speed = vel_before_coll.y

		var filtered = fall_shake_thresholds.filter(func(thresh): return fall_speed >= thresh["threshold"])
		filtered.sort_custom(func(a, b): return a["threshold"] >= b["threshold"])

		if filtered.size() > 0:
			var thresh = filtered[0]
			var shake = thresh["shake"]
			# var damage = thresh["damage"]
			# var shake_factor = actor.get("shake_factor", 0.3)
			Cam.screenshake(shake*0.3)
			DJZ.play(thresh["sound"])

		machine.transit("Idle")
		return
