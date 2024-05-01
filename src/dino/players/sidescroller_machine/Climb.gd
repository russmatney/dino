extends State


func enter(_ctx={}):
	actor.anim.play("climb")
	actor.velocity.y = 0
	Sounds.play(Sounds.S.climbstart)


func physics_process(_delta):
	if Input.is_action_just_pressed("jump"):
		actor.flip_facing()
		machine.transit("Jump")
		return

	if actor.move_vector.y > 0:
		actor.velocity.y = -actor.climb_speed
	elif actor.move_vector.y < 0:
		actor.velocity.y = actor.climb_speed
	elif actor.move_vector.y == 0:
		actor.velocity.y = 0

	actor.move_and_slide()

	if not actor.wall_checks.any(func(w): return w.is_colliding()):
		machine.transit("Fall", {"can_jump": true})

	# if low but not high, climb over the corner
