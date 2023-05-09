extends State

var grabbed

var grab_time = 0.8
var grab_ttl

## enter ###########################################################

func enter(opts = {}):
	Debug.pr("Grab", opts)

	grabbed = opts.get("grabbed")
	Debug.pr("grabbed set", grabbed)

	grab_ttl = grab_time


## exit ###########################################################

func exit():
	grabbed = null
	Hood.notif("Grab.grabbed cleared")


## input ###########################################################

func unhandled_input(event):
	if Trolley.is_attack(event):
		var direction = Vector2.UP
		if grabbed.global_position.x > actor.global_position.x:
			direction = Vector2.LEFT
		elif grabbed.global_position.x < actor.global_position.x:
			direction = Vector2.RIGHT

		grabbed.machine.transit("Thrown", {thrown_by=actor, direction=direction})
		transit("Throw", {body=grabbed})

		return

## physics ###########################################################

func physics_process(delta):
	if grab_ttl == null:
		return

	grab_ttl -= delta

	if grab_ttl <= 0:
		transit("Idle")
		return
