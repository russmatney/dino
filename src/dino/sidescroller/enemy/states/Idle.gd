extends State

var ttr
var wait_to_run = 2
var stop

## properties ###########################################################

func can_be_initial_state():
	return false

## enter #####################################################################

func enter(ctx={}):
	stop = ctx.get("stop")
	actor.anim.play("idle")

	ttr = wait_to_run

## process #####################################################################

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

## animations #####################################################################

func on_frame_changed():
	if actor.anim.animation == "idle":
		# TODO this behavior needs to be custom/opt-in!! :/
		# via some reverse-los-frames or something
		if actor.anim.frame in [3, 4, 5, 6]:
			for _los in actor.line_of_sights:
				U.update_los_facing(-1*actor.facing_vector, _los)
		else:
			for _los in actor.line_of_sights:
				U.update_los_facing(actor.facing_vector, _los)
