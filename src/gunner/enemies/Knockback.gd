extends State

var knockback_impulse = 70
var knockback_y = 700
var knockback_time = 2
var knocked_back

var dir
var dead

var time_left = 0

func enter(msg = {}):
	knocked_back = true

	dir = msg["dir"]
	dead = msg["dead"]

	actor.velocity = Vector2(dir.x * knockback_impulse, -1 * knockback_y)

	if dead:
		actor.velocity *= 3

	if dead:
		actor.anim.animation = "dying"
	else:
		actor.anim.animation = "knockback"

	time_left = knockback_time


func process(delta: float):
	time_left -= delta

	# if we've flown a bit
	if knockback_time - time_left > 0.5:
		# and we're back on the floor
		if actor.is_on_floor():
			knocked_back = false
			if dead:
				transit("Dead")
			else:
				transit("Idle")

	# fallback, in case we fly for a long while
	if time_left < 0:
		knocked_back = false
		if dead:
			transit("Dead")
		else:
			transit("Idle")

	actor.velocity.y += actor.gravity * delta
	actor.velocity = actor.move_and_slide(actor.velocity, Vector2.UP)
