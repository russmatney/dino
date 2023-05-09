extends State

var punch_time = 0.4
var punch_ttl

var initial_punch_count = 0
var punch_count

var punched_again_pressed

## enter ###########################################################

func enter(opts = {}):
	punch_count = Util.get_(opts, "punch_count", initial_punch_count)

	punched_again_pressed = false
	punch_ttl = punch_time

	actor.punch()

func exit():
	punch_ttl = null

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
		if punched_again_pressed and punch_count == 0:
			transit("Punch", {punch_count=1})
		# elif punched_again_pressed and punch_count == 1:
		# 	transit("Kick")
		else:
			transit("Idle")
		return

	actor.velocity = Vector2.ZERO
	actor.move_and_slide()
