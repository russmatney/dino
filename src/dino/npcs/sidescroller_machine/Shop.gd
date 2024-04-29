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


## enter #####################################################################

func enter(_ctx={}):
	actor.anim.play("shop")

	# TODO gather priorities into constants?
	if actor.pcam:
		actor.pcam.priority = 5

## exit #####################################################################

func exit():
	if actor.pcam:
		actor.pcam.priority = 0

## process #####################################################################

func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.speed)
	actor.move_and_slide()
