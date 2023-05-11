extends State

var punch_time = 0.4
var punch_ttl

var initial_punch_count = 0
var punch_count
var punched_again_pressed

var hit_anything

var next_state

## enter ###########################################################

func enter(opts = {}):
	punch_count = Util.get_(opts, "punch_count", initial_punch_count)

	punched_again_pressed = false
	punch_ttl = punch_time

	hit_anything = actor.punch()

	if hit_anything and punch_count >= 1:
		# connected second punch of combo
		Cam.screenshake(0.3)

	next_state = opts.get("next_state")

func exit():
	punch_ttl = null
	next_state = null


## unhandled_input ###########################################################

func unhandled_input(event):
	if Trolley.is_attack(event) and not punched_again_pressed:
		punched_again_pressed = true
		return

## physics ###########################################################

func physics_process(delta):
	if punch_ttl == null:
		return

	punch_ttl -= delta

	if punch_ttl <= 0:
		# AI combo support
		if next_state != null:
			transit(next_state, {
				hit_anything=hit_anything,
				punch_count=punch_count + 1,
				})
		# player combo support
		elif hit_anything and punched_again_pressed and punch_count == 0:
			transit("Punch", {punch_count=1})
		elif hit_anything and punched_again_pressed and punch_count == 1:
			transit("Kick")
		else:
			transit("Idle")
		return

	actor.velocity = Vector2.ZERO
	actor.move_and_slide()
