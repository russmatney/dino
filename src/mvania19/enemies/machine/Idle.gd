extends State


var ttr
var wait_to_run = 3
var stop

func enter(ctx={}):
	stop = ctx.get("stop")
	actor.anim.play("idle")

	ttr = wait_to_run


func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	if stop:
		actor.velocity.x = 0
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)

	actor.move_and_slide()

	# TODO consider a new state for when we can see the player
	for lo in actor.line_of_sights:
		if lo.is_colliding():
			# run towards collision
			if lo.target_position.y > 0:
				machine.transit("Run", {dir=Vector2.LEFT})
			elif lo.target_position.y < 0:
				machine.transit("Run", {dir=Vector2.RIGHT})
			return

	if ttr:
		ttr -= delta
		if ttr <= 0:
			machine.transit("Run")
