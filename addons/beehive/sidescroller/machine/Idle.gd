extends State

var wander_in = [0.7, 1.3, 2.0]
var wander_in_t

## enter ###########################################################

func enter(_opts = {}):
	actor.anim.play("idle")

	if actor.should_wander:
		wander_in_t = Util.rand_of(wander_in)


## exit ###########################################################

func exit():
	pass


## physics ###########################################################

func physics_process(delta):
	if actor.is_player and Input.is_action_just_pressed("jump") and actor.is_on_floor():
		machine.transit("Jump")
		return

	if actor.move_vector.x != 0:
		machine.transit("Run")
		return

	if actor.should_wander:
		wander_in_t -= delta
		if wander_in_t <= 0:
			transit("Wander")
			return

	# slow down
	actor.velocity.x = lerp(actor.velocity.x, 0.0, 0.5)

	# gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	actor.move_and_slide()
