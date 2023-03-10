extends State

var stunned_for = 3
var stunned_ttl

func enter(ctx={}):
	stunned_ttl = ctx.get("stunned_for", stunned_for)

	actor.anim.play("seated")
	Cam.hitstop("monstroar_stunned", 0.5, 0.3, 0.3)
	# TODO monstroar sound
	MvaniaSounds.play_sound("soldierdead")
	actor.stunned.emit(actor)


func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)

	actor.move_and_slide()

	stunned_ttl -= delta
	if stunned_ttl <= 0:
		machine.transit("Idle", {wait_for=2, next_state="Warping"})
