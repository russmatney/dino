extends State

## properties ###################################

func can_bump():
	return false

func can_attack():
	return false

func can_hop():
	return false

func can_be_initial_state():
	return true

## vars ###################################

var ttl
var walk_in_t = 2
var stop: bool = false

## enter #####################################################################

func enter(ctx={}):
	actor.anim.play("idle")
	ttl = walk_in_t
	stop = ctx.get("stop", false)

## process #####################################################################

func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	if stop:
		actor.velocity.x = 0
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, actor.speed)

	actor.move_and_slide()

	if ttl:
		ttl -= delta
		if ttl <= 0:
			machine.transit("Walk")
