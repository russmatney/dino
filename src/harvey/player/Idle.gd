extends State


func enter(_ctx = {}):
	owner.anim.animation = "idle"


func process(_delta):
	var move_dir = Trolley.move_dir()

	if abs(move_dir.length()) > 0:
		machine.transit("Run")
