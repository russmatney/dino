extends State

## properties #####################################################

func should_ignore_hit():
	return false

func can_bump():
	return false

## vars #####################################################

var laugh_at_least = 1
var laugh_ttl
var next_state

## enter #####################################################

func enter(ctx={}):
	actor.anim.play("laughing")
	Sounds.play(Sounds.S.bosslaugh)
	laugh_ttl = ctx.get("wait_for", laugh_at_least)

	next_state = ctx.get("next_state")

## exit #####################################################

func exit():
	laugh_ttl = laugh_at_least

## process #####################################################

func physics_process(delta):
	if not actor.can_float:
		actor.velocity.y += actor.gravity * delta
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.speed/5.0)
	actor.move_and_slide()

	if actor.is_dead:
		machine.transit("Dead", {ignore_side_effects=true})
		return

	laugh_ttl -= delta
	if laugh_ttl <= 0:
		if next_state:
			machine.transit(next_state)
		else:
			machine.transit("Idle")
