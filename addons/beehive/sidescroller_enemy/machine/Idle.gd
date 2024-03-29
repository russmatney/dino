extends State


var ttr
var wait_to_run = 2
var stop

func enter(ctx={}):
	stop = ctx.get("stop")
	actor.anim.play("idle")

	ttr = wait_to_run


func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	if stop:
		actor.velocity.x = 0
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, actor.speed)

	actor.move_and_slide()

	# consider a new state for when we can see the player
	var los = actor.line_of_sights if "line_of_sights" in actor else []
	for lo in los:
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
