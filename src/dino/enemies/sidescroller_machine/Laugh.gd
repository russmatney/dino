extends State

## properties ###################################

func can_bump():
	return false

func can_attack():
	return false

func can_hop():
	return false

## vars ###################################

var laugh_at_least = 1
var laugh_ttl
var next_state

## enter ###################################

func enter(ctx={}):
	# actor.anim.play("laughing")
	Sounds.play(Sounds.S.enemylaugh)

	laugh_ttl = ctx.get("wait_for", laugh_at_least)

	next_state = ctx.get("next_state")

## exit ###################################

func exit():
	laugh_ttl = laugh_at_least

## process ###################################

func physics_process(delta):
	if actor.should_crawl_on_walls:
		# wall-crawlers shouldn't fall (stay on the wall)
		pass
	else:
		actor.velocity.y += actor.gravity * delta
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.speed/5.0)
	actor.move_and_slide()

	if actor.health <= 0:
		machine.transit("Dead", {ignore_side_effects=true})
		return

	laugh_ttl -= delta
	if laugh_ttl <= 0:
		machine.transit("Idle")
