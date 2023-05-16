extends State

var idle_times = [0.7, 1.3, 2.0]
var idle_ttl

## enter ###########################################################

func enter(_opts = {}):
	actor.anim.play("idle")

	if actor.should_wander:
		idle_ttl = Util.rand_of(idle_times)


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

	if actor.should_wander or actor.should_patrol:
		idle_ttl -= delta
		if idle_ttl <= 0:
			if actor.should_patrol:
				transit("Patrol")
			elif actor.should_wander:
				transit("Wander")
			return

	# slow down
	actor.velocity.x = lerp(actor.velocity.x, 0.0, 0.5)

	# gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	actor.move_and_slide()
