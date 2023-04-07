extends State


func enter(ctx={}):
	var _body = ctx.get("body")
	actor.anim.play("kick")
	actor.move_dir = Vector2.ZERO


func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	actor.velocity.x = lerp(actor.velocity.x, 0.0, 0.1)

	actor.move_and_slide()
