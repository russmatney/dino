extends State


func enter(_ctx={}):
	actor.anim.play("climb")
	actor.velocity.y = 0
	DJZ.play(DJZ.climbstart)


func physics_process(_delta):
	if Input.is_action_just_pressed("jump") \
		and actor.can_execute_any_actions():
		machine.transit("Jump", {dir=actor.facing * -1})
		return

	if actor.move_dir.y > 0:
		actor.velocity.y = -actor.CLIMB_SPEED
	elif actor.move_dir.y < 0:
		actor.velocity.y = actor.CLIMB_SPEED
	elif actor.move_dir.y == 0:
		actor.velocity.y = 0

	actor.move_and_slide()

	if not actor.wall_checks.any(func(w): return w.is_colliding()):
		machine.transit("Fall", {"can_jump": true})

	# TODO if low but not high, climb over the corner
