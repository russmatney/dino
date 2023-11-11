extends State


func enter(_msg = {}):
	Log.pr("entering attack state for actor: ", actor)


var once = true


func process(_delta: float):
	if actor.bodies.size() == 0:
		machine.transit("Idle")
		return

	var target = actor.bodies[0]

	if once:
		actor.bowl_attack(target)
		once = false
