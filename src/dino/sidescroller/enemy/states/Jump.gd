extends State

## properties ###################################

func can_bump():
	return true

func can_attack():
	return false

## enter ###################################

func enter(_ctx={}):
	actor.anim.play("jump")

## process ###################################

func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	actor.move_and_slide()
