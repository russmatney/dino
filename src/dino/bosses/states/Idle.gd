extends State

## properties #####################################################

func should_ignore_hit():
	return false

func can_bump():
	return true

## vars #####################################################

var wait_at_least = 1
var wait_ttl
var next_state

## enter #####################################################

func enter(ctx={}):
	actor.anim.play("idle")

	wait_ttl = ctx.get("wait_for", wait_at_least)

	next_state = ctx.get("next_state")

## exit #####################################################

func exit():
	wait_ttl = wait_at_least

## process #####################################################

func physics_process(delta):
	if not actor.can_float:
		actor.velocity.y += actor.gravity * delta
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.speed/5.0)
	actor.move_and_slide()

	if actor.is_dead:
		machine.transit("Dead", {ignore_side_effects=true})
		return

	wait_ttl -= delta
	if wait_ttl <= 0:
		if next_state:
			machine.transit(next_state)
		else:
			var next_states = ["Warping"]
			if actor.can_swoop:
				next_states.append("Swoop")
			if actor.can_fire:
				next_states.append("Firing")
			machine.transit(U.rand_of(next_states))
