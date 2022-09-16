extends State


func enter(_msg = {}):
	print("entering idle state for actor: ", actor)

	# owner points to the root node of a packed scene
	actor.velocity = Vector2.ZERO


func process(_delta: float):
	# check for nearby player
	pass
