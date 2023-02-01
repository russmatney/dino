extends State

var shoot_every = 1
var tt_shoot


func enter(_ctx = {}):
	print("entering attack")
	actor.velocity = Vector2.ZERO
	tt_shoot = shoot_every


func process(delta):
	if actor.player:
		tt_shoot -= delta
		if tt_shoot <= 0:
			actor.fire_at_player()
			tt_shoot = shoot_every
	else:
		machine.transit("Idle")


func physics_process(delta):
	actor.velocity.y += actor.gravity * delta
	actor.velocity = actor.move_and_slide(actor.velocity, Vector2.UP)
