extends State

var double_jumping
var double_jump_wait = 0.1
var double_jump_ttl

func enter(ctx={}):
	double_jumping = ctx.get("double_jumping", false)

	MvaniaSounds.play_sound("jump")
	actor.anim.play("jump")
	actor.anim.animation_finished.connect(_on_anim_finished)

	# TODO remove?
	Cam.hitstop("lmao_jump_hitstop", 0.5, 0.3)
	# actor.action_hint.display("jump", "Jump")
	# actor.stamp({"scale": 0.1, "ttl": 0.4})

	# apply horizontal push
	var dir = ctx.get("dir", Vector2.ZERO)
	if dir:
		actor.velocity.x = actor.move_dir.x * actor.SPEED

	# apply jump velocity
	actor.velocity.y = actor.JUMP_VELOCITY

	if actor.has_double_jump:
		double_jump_ttl = double_jump_wait

func _on_anim_finished():
	if actor.anim.animation == "jump":
		actor.anim.play("air")

func exit():
	actor.anim.animation_finished.disconnect(_on_anim_finished)

func physics_process(delta):
	if actor.has_double_jump:
		if double_jump_ttl == null:
			double_jump_ttl = double_jump_wait
		double_jump_ttl -= delta

	# double jump
	if not double_jumping and actor.has_double_jump \
		and double_jump_ttl <= 0 \
		and Input.is_action_just_pressed("jump") \
		and actor.can_execute_any_actions():
		machine.transit("Jump", {"double_jumping": true})
		return

	# gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	# apply move dir
	# TODO consider different air horizontal speed
	if actor.move_dir:
		actor.velocity.x = actor.move_dir.x * actor.SPEED
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)

	if actor.has_climb and actor.is_on_wall_only()\
		and not actor.near_ground_check.is_colliding():
		var coll = actor.get_slide_collision(0)
		var x_diff = coll.get_position().x - actor.global_position.x

		if actor.move_dir.x > 0 and x_diff > 0:
			machine.transit("Climb")
			return
		if actor.move_dir.x < 0 and x_diff < 0:
			machine.transit("Climb")
			return


	actor.move_and_slide()

	if actor.velocity.y > 0:
		machine.transit("Fall", {"double_jumping": double_jumping})
