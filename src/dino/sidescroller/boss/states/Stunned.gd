extends State

## properties #####################################################

func should_ignore_hit():
	return false

func can_bump():
	return false

## vars #####################################################

var stunned_for = 3
var stunned_ttl

## enter #####################################################

func enter(ctx={}):
	stunned_ttl = ctx.get("stunned_for", stunned_for)

	actor.anim.play("stunned")
	Cam.hitstop("boss_stunned", 0.5, 0.3, 0.3)
	DJZ.play(DJZ.S.soldierdead)
	actor.stunned.emit(actor)

## process #####################################################

func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.speed)

	actor.move_and_slide()

	stunned_ttl -= delta
	if stunned_ttl <= 0:
		machine.transit("Idle", {wait_for=0.5, next_state="Warping"})
