extends State


func enter(ctx={}):
	var dir = ctx.get("dir", Vector2.LEFT)
	actor.move_dir = dir
	actor.anim.play("run")


func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	if actor.move_dir.length() > 0:
		actor.velocity.x = actor.move_dir.x * actor.SPEED

	if actor.move_dir.x > 0:
		actor.face_right()
	elif actor.move_dir.x < 0:
		actor.face_left()

	actor.move_and_slide()

	if not actor.front_ray.is_colliding():
		actor.turn()

	if actor.is_on_wall():
		actor.turn()
