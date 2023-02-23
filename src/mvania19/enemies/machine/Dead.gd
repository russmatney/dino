extends State


func enter(ctx={}):
	actor.anim.play("dead")
	if not ctx.get("ignore_side_effects", false):
		Cam.screenshake(0.3)
		MvaniaSounds.play_sound("soldierdead")


func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	actor.move_and_slide()
