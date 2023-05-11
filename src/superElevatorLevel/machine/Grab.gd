extends State

var grabbed

var grab_time = 0.8
var grab_ttl

var throw_direction

## enter ###########################################################

func enter(opts = {}):
	grabbed = opts.get("grabbed")
	grab_ttl = grab_time

	if grabbed.global_position.x > actor.global_position.x:
		throw_direction = Vector2.LEFT
	elif grabbed.global_position.x < actor.global_position.x:
		throw_direction = Vector2.RIGHT

## exit ###########################################################

func exit():
	grabbed = null
	throw_direction = null


## input ###########################################################

func unhandled_input(event):
	if Trolley.is_attack(event):
		grabbed.machine.transit("Thrown", {thrown_by=actor, direction=throw_direction})
		transit("Throw", {body=grabbed})

## physics ###########################################################

func physics_process(delta):
	if grab_ttl == null:
		return

	grab_ttl -= delta

	if grab_ttl <= 0:
		if grabbed.machine.state.name == "Grabbed":
			grabbed.machine.transit("Idle")
		transit("Idle")
		return
