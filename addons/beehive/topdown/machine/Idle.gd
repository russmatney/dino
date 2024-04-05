extends State

var wander_in = [0.8, 2.2, 1.5]
var wander_in_t

## enter ###########################################################

func enter(_opts = {}):
	# clear movement input (so transting to idle doesn't get stuck in an idle/run loop)
	actor.move_vector = Vector2.ZERO

	if actor.should_wander:
		wander_in_t = U.rand_of(wander_in)

## exit ###########################################################

func exit():
	pass


## input ###########################################################

func unhandled_input(event):
	if actor.is_player:
		if Trolls.is_jump(event):
			machine.transit("Jump")
			return

## physics ###########################################################

func physics_process(delta):
	actor.update_idle_anim()

	if actor.move_vector.abs().length() > 0:
		machine.transit("Run")
		return

	if actor.should_notice:
		if len(actor.notice_box_bodies) > 0:
			transit("Notice", {noticing=actor.notice_box_bodies[0]})
			return

	if actor.should_wander:
		wander_in_t -= delta
		if wander_in_t <= 0:
			transit("Wander")
			return

	# slow down
	actor.velocity = lerp(actor.velocity, Vector2.ZERO, 0.5)

	actor.move_and_slide()
