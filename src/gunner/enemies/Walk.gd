extends State

var walk_for = 3
var tt_idle


func enter(ctx = {}):
	actor.anim.animation = "run"
	actor.move_dir = ctx.get("dir")
	if not actor.move_dir:
		actor.move_dir = [Vector2.RIGHT, Vector2.LEFT][randi() % 2]
	actor.face_dir(actor.move_dir)

	tt_idle = walk_for


func physics_process(delta):
	tt_idle -= delta
	if tt_idle <= 0:
		machine.transit("Idle")
		return

	actor.velocity.x = actor.speed * actor.move_dir.x
	actor.velocity.y += actor.gravity * delta
	actor.set_velocity(actor.velocity)
	actor.set_up_direction(Vector2.UP)
	actor.move_and_slide()
	actor.velocity = actor.velocity

	if actor.move_dir.x > 0:
		actor.face_right()
	elif actor.move_dir.x < 0:
		actor.face_left()

	if not actor.front_ray.is_colliding():
		actor.turn()
		actor.move_dir = actor.facing_dir

	if actor.is_on_wall():
		actor.turn()
		actor.move_dir = actor.facing_dir
