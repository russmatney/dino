extends State


func enter(_msg = {}):
	owner.velocity = Vector2.ZERO
	owner.anim.animation = "dead"
	owner.dead = true


func process(_delta: float):
	pass
