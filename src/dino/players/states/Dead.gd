extends State

## properties ###########################################################

func ignore_input():
	return true

func can_bump():
	return false

func can_act():
	return false

## enter ###########################################################

func enter(_opts = {}):
	actor.anim.play("dead")
	actor.died.emit()


## physics ###########################################################

func physics_process(_delta):
	actor.velocity = actor.velocity.lerp(Vector2.ZERO, 0.8)
	actor.move_and_slide()
