extends State

var kick_time = 0.5
var kick_ttl
var hit_anything

## enter ###########################################################

func enter(_opts = {}):
	kick_ttl = kick_time

	hit_anything = kick()


## exit ###########################################################

func exit():
	kick_ttl = null


## kick ###########################################################

func kick():
	var did_hit
	for body in actor.punch_box_bodies:
		if not body.is_dead and "machine" in body:
			body.machine.transit("Kicked", {kicked_by=actor, direction=actor.facing_vector})
			did_hit = true
	return did_hit


## physics ###########################################################

func physics_process(delta):
	if kick_ttl == null:
		return

	kick_ttl -= delta

	if kick_ttl <= 0:
		transit("Idle")
		return

	actor.velocity = Vector2.ZERO
	actor.move_and_slide()
