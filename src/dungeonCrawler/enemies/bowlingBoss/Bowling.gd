extends State

var windup_time: int
var bowling = false
var bowled = false

func enter(_msg = {}):
	print("[BOWLING]", actor)

	windup_time = 80
	bowling = false
	bowled = false

func process(delta):
	if actor.dead:
		machine.transit("Dead")
	if windup_time > 0:
		windup_time -= delta
	else:
		if actor.bodies.size():
			var target = actor.bodies[0]
			if target and not bowling:
				bowling = true
				actor.bowl_attack(target) # yields until finished
				yield(get_tree().create_timer(1.0), "timeout")
				bowled = true

			if bowled:
				machine.transit("Moving")
