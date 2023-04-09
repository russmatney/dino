extends State


func enter(_msg = {}):
	Debug.pr("entering attack state for actor: ", actor)


var once = true


func process(_delta: float):
	if actor.bodies.size() == 0:
		machine.transit("Idle")
		return

	var target = actor.bodies[0]

	# TODO tell before attacking, pause/move after
	if once:
		actor.bowl_attack(target)
		once = false
