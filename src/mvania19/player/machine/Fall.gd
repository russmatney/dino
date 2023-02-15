extends State

var fall_shake_thresholds = [
	{"threshold": 400, "shake": 0.3, "damage": 0, "sound": "fall"},
	{"threshold": 550, "shake": 0.6, "damage": 1, "sound": "heavy_fall"},
	{"threshold": 1000, "shake": 1.0, "damage": 2, "sound": "heavy_fall"},
	]

var coyote_time_t = 0.18
var coyote_ttj

func enter(ctx={}):
	actor.anim.play("air")

	if "coyote_time" in ctx:
		coyote_ttj = coyote_time_t
		print("coyote time begins")
	else:
		coyote_ttj = null

func physics_process(delta):
	# support jumping in coyote time
	if not coyote_ttj == null:
		coyote_ttj -= delta

		if coyote_ttj > 0:
			if Input.is_action_just_pressed("jump"):
				machine.transit("Jump")
		else:
			print("coyote time over")
			coyote_ttj = null

	# gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	# horizontal speed up or slowdown
	if actor.move_dir:
		actor.velocity.x = actor.move_dir.x * actor.SPEED
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)

	var vel_before_coll = actor.velocity
	actor.move_and_slide()

	# move back to idle
	if actor.is_on_floor():
		var fall_speed = vel_before_coll.y
		print("fall_speed was: ", fall_speed)

		var filtered = fall_shake_thresholds.filter(func(thresh): return fall_speed >= thresh["threshold"])
		filtered.sort_custom(func(a, b): return a["threshold"] >= b["threshold"])

		if filtered.size() > 0:
			var thresh = filtered[0]
			var shake = thresh["shake"]
			# var damage = thresh["damage"]
			Cam.screenshake(shake)
			MvaniaSounds.play_sound(thresh["sound"])

		# apply damage
		# apply shake
		# if not actor.is_dead:
		# 	machine.transit("Idle", {"shake": shake})
		machine.transit("Idle")
