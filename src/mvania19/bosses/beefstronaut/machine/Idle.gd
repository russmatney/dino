extends State

var wait_ttl

func enter(ctx={}):
	actor.anim.play("idle")

	wait_ttl = ctx.get("wait_for", 0)

func physics_process(delta):
	wait_ttl -= delta

	if wait_ttl <= 0:
		# TODO warp after firing
		machine.transit("Firing")
		return

	actor.velocity.y += actor.GRAVITY * delta
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED/5.0)
	actor.move_and_slide()
