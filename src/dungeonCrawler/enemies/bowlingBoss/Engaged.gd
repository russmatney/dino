extends State

var wait_time: int = 0

func enter(_msg = {}):
	print("[ENGAGED]", actor)
	wait_time = 100

func process(delta):
	if actor.dead:
		machine.transit("Dead")

	wait_time -= delta

	if wait_time <= 0:
		if actor.bodies.size():
			machine.transit("Bowling")
		else:
			machine.transit("Idle")
