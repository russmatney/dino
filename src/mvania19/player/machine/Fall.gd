extends State

var fall_shake_thresholds = [
	{"threshold": 400, "shake": 0.3, "damage": 0, "sound": "fall"},
	{"threshold": 550, "shake": 0.6, "damage": 1, "sound": "heavy_fall"},
	{"threshold": 1000, "shake": 1.0, "damage": 2, "sound": "heavy_fall"},
	]

var coyote_time_t = 0.2
var double_jump_coyote_time_t = 0.4
var coyote_ttj

var can_jump

var double_jumping

func enter(ctx={}):
	double_jumping = ctx.get("double_jumping")
	actor.anim.play("air")

	can_jump = ctx.get("can_jump", false)

	# TODO just let 'em jump?
	if ctx.get("coyote_time", false):
		if actor.has_double_jump:
			coyote_ttj = double_jump_coyote_time_t
		else:
			coyote_ttj = coyote_time_t
	else:
		coyote_ttj = null

func physics_process(delta):
	# support jumping in coyote time
	if not coyote_ttj == null:
		coyote_ttj -= delta

		if coyote_ttj > 0:
			if Input.is_action_just_pressed("jump") and actor.can_execute_any_actions():
				machine.transit("Jump")
				return
		else:
			coyote_ttj = null

	# double jump
	if not double_jumping and actor.has_double_jump \
		and Input.is_action_just_pressed("jump") \
		and actor.can_execute_any_actions():
		machine.transit("Jump", {"double_jumping": true})
		return

	# jump after climb
	if can_jump and Input.is_action_just_pressed("jump") \
		and actor.can_execute_any_actions():
		machine.transit("Jump")
		return

	# gravity
	if not actor.is_on_floor_only():
		actor.velocity.y += actor.GRAVITY * delta

	# horizontal speed up or slowdown
	if actor.move_dir:
		actor.velocity.x = actor.move_dir.x * actor.SPEED
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)

	var vel_before_coll = actor.velocity
	actor.move_and_slide()

	if actor.has_climb and actor.is_on_wall_only() \
		and not actor.near_ground_check.is_colliding():
		var coll = actor.get_slide_collision(0)
		var x_diff = coll.get_position().x - actor.global_position.x

		if actor.move_dir.x > 0 and x_diff > 0:
			machine.transit("Climb")
			return
		if actor.move_dir.x < 0 and x_diff < 0:
			machine.transit("Climb")
			return

	# move back to idle
	if actor.is_on_floor():
		var fall_speed = vel_before_coll.y

		var filtered = fall_shake_thresholds.filter(func(thresh): return fall_speed >= thresh["threshold"])
		filtered.sort_custom(func(a, b): return a["threshold"] >= b["threshold"])

		if filtered.size() > 0:
			var thresh = filtered[0]
			var shake = thresh["shake"]
			# var damage = thresh["damage"]
			Cam.screenshake(shake)
			MvaniaSounds.play_sound(thresh["sound"])

		# TODO apply damage
		# if not actor.is_dead:
		# 	machine.transit("Idle", {"shake": shake})
		machine.transit("Idle")
