extends State


func enter(_ctx={}):
	actor.anim.play("idle")


func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	actor.move_and_slide()

	if actor.los.is_colliding():
		# run towards collision
		if actor.los.target_position.y > 0:
			machine.transit("Run", {dir=Vector2.LEFT})
		elif actor.los.target_position.y < 0:
			machine.transit("Run", {dir=Vector2.RIGHT})
