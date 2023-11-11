extends State


func enter(_msg = {}):
	Log.pr("[IDLE]", actor)
	# owner points to the root node of a packed scene
	# actor.velocity = Vector2.ZERO


func process(_delta: float):
	if actor.dead:
		machine.transit("Dead")
	if actor.bodies.size() > 0:
		machine.transit("Engaged", {"body": actor.bodies[0]})
