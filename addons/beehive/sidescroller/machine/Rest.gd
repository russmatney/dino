extends State

var rest_time = 2.2
var rest_ttl

## enter ###########################################################

func enter(opts = {}):
	actor.anim.play("rest")
	rest_ttl = opts.get("rest_time", rest_time)
	actor.recover_health()


## exit ###########################################################

func exit():
	rest_ttl = null


## physics ###########################################################

func physics_process(delta):
	rest_ttl -= delta
	if rest_ttl <= 0:
		transit("Idle")
		return

	actor.move_and_slide()

