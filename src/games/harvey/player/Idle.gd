extends State


func enter(_ctx = {}):
	actor.anim.animation = "idle"


func process(_delta):
	var move_dir = actor.get_move_dir()
	if move_dir:
		if abs(move_dir.length()) > 0:
			machine.transit("Run")
