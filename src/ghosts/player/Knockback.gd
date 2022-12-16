extends State

var knockback_impulse = 200
var knockback_y = 700
var knockback_time = 2

var dir
var dead

var time_left = 0

func enter(msg = {}):
	owner.knocked_back = true

	dir = msg["dir"]
	dead = msg["dead"]

	owner.velocity = Vector2(dir.x * knockback_impulse, -1 * knockback_y)

	if dead:
		owner.velocity *= 3

	if dead:
		owner.anim.animation = "dying"
	else:
		owner.anim.animation = "knockback"

	time_left = knockback_time


func process(delta: float):
	time_left -= delta

	# if we've flown a bit
	if knockback_time - time_left > 0.5:
		# and we're back on the floor
		if owner.is_on_floor():
			owner.knocked_back = false
			if dead:
				transit("Dead")
			else:
				transit("Idle")

	# fallback, in case we fly for a long while
	if time_left < 0:
		owner.knocked_back = false
		if dead:
			transit("Dead")
		else:
			transit("Idle")

	owner.velocity.y += owner.gravity * delta
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
