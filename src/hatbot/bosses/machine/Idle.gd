extends State

var wait_at_least = 1
var wait_ttl
var next_state

func enter(ctx={}):
	actor.anim.play("idle")

	wait_ttl = ctx.get("wait_for", wait_at_least)

	next_state = ctx.get("next_state")

func exit():
	wait_ttl = wait_at_least

func physics_process(delta):

	# TODO floaty wiggle
	if not actor.can_float:
		actor.velocity.y += actor.GRAVITY * delta
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED/5.0)
	actor.move_and_slide()

	if actor.is_dead:
		machine.transit("Dead", {ignore_side_effects=true})
		return

	wait_ttl -= delta
	if wait_ttl <= 0:
		if next_state:
			machine.transit(next_state)
		elif actor.can_swoop:
			machine.transit("Swoop")
		else:
			machine.transit("Firing")
