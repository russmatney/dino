extends State


func enter(_ctx={}):
	actor.anim.play("run")


func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	actor.move_and_slide()
