extends State


func enter(_ctx={}):
	actor.anim.play("idle")


func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	actor.move_and_slide()

	for lo in actor.line_of_sights:
		if lo.is_colliding():
			# run towards collision
			if lo.target_position.y > 0:
				machine.transit("Run", {dir=Vector2.LEFT})
			elif lo.target_position.y < 0:
				machine.transit("Run", {dir=Vector2.RIGHT})
