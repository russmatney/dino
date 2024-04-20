extends State

## properties ###################################

func can_bump():
	return false

func can_attack():
	return false

func can_be_initial_state():
	return true

func can_hop():
	return false

## vars ###################################

var ttl
var t = 0.2

## enter #####################################################################

func enter(_ctx={}):
	actor.anim.play("idle")

	ttl = t

## process #####################################################################

func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	actor.velocity.x = 0

	actor.move_and_slide()

	if ttl:
		ttl -= delta
		if ttl <= 0:
			machine.transit("Idle")
