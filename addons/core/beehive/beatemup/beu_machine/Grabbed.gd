extends State

var escape_in = [0.4, 0.8, 1.3]
var escape_in_t


## enter ###########################################################

func enter(_opts = {}):
	actor.anim.play("grabbed")
	escape_in_t = U.rand_of(escape_in)


## exit ###########################################################

func exit():
	escape_in_t = null


## physics ###########################################################

func physics_process(delta):
	if escape_in_t == null:
		return
	escape_in_t -= delta
	if escape_in_t <= 0:
		# transit("Escape")
		transit("Idle")
		return

	if actor.velocity.abs().length() > 0:
		actor.velocity = actor.velocity.lerp(Vector2.ZERO, 0.99)
	actor.move_and_slide()
