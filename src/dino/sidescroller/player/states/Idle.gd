extends State

var idle_times = [0.7, 1.3, 2.0]
var idle_ttl

## properties ###########################################################

func can_be_initial_state():
	return true

## enter ###########################################################

func enter(_opts = {}):
	actor.anim.play("idle")

## physics ###########################################################

func physics_process(delta):
	if Input.is_action_just_pressed("jump") and actor.is_on_floor():
		machine.transit("Jump")
		return

	if actor.move_vector.x != 0:
		machine.transit("Run")
		return

	# slow down
	actor.velocity.x = lerp(actor.velocity.x, 0.0, 0.5)

	# gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	actor.move_and_slide()
