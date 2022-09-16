extends State


func enter(_msg = {}):
	print("entering attack state for actor: ", actor)


func process(_delta: float):
	if actor.bodies.size() == 0:
		machine.transit("Idle")
