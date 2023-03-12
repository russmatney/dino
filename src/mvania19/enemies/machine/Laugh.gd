extends State

var laugh_at_least = 1
var laugh_ttl
var next_state

func enter(ctx={}):
	# actor.anim.play("laughing")
	# TODO enemy laugh noise

	laugh_ttl = ctx.get("wait_for", laugh_at_least)

	next_state = ctx.get("next_state")

func exit():
	laugh_ttl = laugh_at_least

func physics_process(delta):
	actor.velocity.y += actor.GRAVITY * delta
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED/5.0)
	actor.move_and_slide()

	if actor.health <= 0:
		machine.transit("Dead", {ignore_side_effects=true})
		return

	laugh_ttl -= delta
	if laugh_ttl <= 0:
		machine.transit("Idle")
