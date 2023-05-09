extends State

var kick_time = 0.5
var kick_ttl
var hit_anything

## enter ###########################################################

func enter(_opts = {}):
	kick_ttl = kick_time

	hit_anything = actor.kick()

func exit():
	kick_ttl = null

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
